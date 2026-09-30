classdef StringWriter < handle
    % StringWriter - Helper class for writing to files or temporary strings
    
    % Copyright 2023, The MathWorks Inc.
    
    properties(SetAccess=private)
        FH = []
        FileName
        String
        IsTemp
        TabLength = 0;
        Tab = '';
        PS = '';
        BaseIndent = 4;
    end
    properties
        RunIndent = false
        IncludeProtection = false
    end
    
    methods
        function this = StringWriter( fileName, varargin )
            if nargin > 0
                this.FileName = fileName;
                this.IsTemp = false;
            else
                this.FileName = tempname;
                this.IsTemp = true;
            end
            N = length(varargin);
            if rem(N,2) ~= 0
                error('Additional arguments must come in pairs');
            end
            for k=1:2:N
                f = varargin{k};
                v = varargin{k+1};
                this.(f) = v;
            end

            this.FH = fopen( this.FileName, 'w' );
            if this.FH < 0
                error('Couldn''t open %s for writing\n', this.FileName );
            end
            if this.IncludeProtection
                this.PS = getProtectString(this);
                this.pf('#ifndef %s\n#define %s\n\n', this.PS, this.PS);
            end
        end
        
        function str = getString( this )
            if isempty( this.String )
                closeFile( this );
            end
            str = this.String;
        end
        
        function insertFile(this, fileName)
           this.pf('%s', fileread(fileName));            
        end
        
%         function fprintf( this, varargin )
%             if isempty( this.FH )
%                 error('This StringWriter has already been closed.' );
%             end
%             fprintf( this.FH, varargin{:} );
%         end
        
        function this = pf( this, varargin )
            % Short-hand for printf
            if isempty( this.FH )
                error('This StringWriter has already been closed.' );
            end
            if this.TabLength > 0
                fprintf(this.FH, '%s', this.Tab);
            end
            fprintf( this.FH, varargin{:} );
        end
        
        function this = nl( this )
           this.pf( '\n' );
           this.tab();
        end
        
        function this = insertLines(this, str)
            % insertLines Splits on \n and inserts lines
            lines = textscan(str, '%s', 'Delimiter', '\n', 'EndOfLine', '\n', 'Whitespace', '');
            lines = [lines{:}];
            for k=1:length(lines)
                this.pf("%s\n", lines{k});
            end
        end
        
        function this = tab( this, num )
            if nargin == 1
                this.pf( '%s', this.Tab );
            else
                this.TabLength = this.TabLength + num;
                if this.TabLength < 0
                    this.TabLength = 0;
                end
                this.Tab = repmat( ' ', 1, this.TabLength );
            end
        end

        function this = indent(this)
            this.tab(this.BaseIndent);
        end
        function this = unindent(this)
            this.tab(-this.BaseIndent);
        end
        
        function delete(this)
            closeFile( this );
        end
        
        
        function this = pfni( this, varargin )
            % Printf no-indent
            if isempty( this.FH )
                error('This StringWriter has already been closed.' );
            end
            fprintf( this.FH, varargin{:} );
        end
        

    end
    methods (Access = private)
        function closeFile( this )
            if ~isempty( this.FH )
                if this.IncludeProtection
                    this.pf('#endif /* %s */\n\n', this.PS);
                end
                fclose( this.FH );
                this.FH = [];
                if this.RunIndent
                   c_indent(this.FileName); 
                end
                this.String = fileread( this.FileName );
                if this.IsTemp
                    delete( this.FileName );
                end
                this.FileName = '';
            end
        end
        
        function str = getProtectString(this)
           str = sprintf('_%s_', upper(strrep(this.FileName, '.', '_')));
        end
    end
end
