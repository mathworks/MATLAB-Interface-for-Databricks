classdef (Abstract) StructOrCellDeserializable < handle
    % matlab.databricks.StructOrCellDeserializable Base class for objects whose properties
    % can be set through a structure or cell-array as typically obtained by
    % JSON decoding a (Databricks) REST response.
    
    methods (Access=protected)
    
        function obj = StructOrCellDeserializable(varargin)
            % matlab.databricks.StructOrCellDeserializable Constructor. Call this from
            % derived classes constructors:
            %
            %   function obj = SomeDerivedClass(varargin)
            %       obj@matlab.databricks.StructOrCellDeserializable(varargin{:})
            %   end
            %
            
            % If there is an input
            if nargin==1
                % And it is a struct or cell
                if (isstruct(varargin{1}) || iscell(varargin{1}))
                    % Use the helper method to copy values from this
                    % struct or cell to properties of the object
                    obj = obj.fromStructOrCell(varargin{1});
                elseif ismissing(varargin{1})
                    % For the specific case where the helper was called
                    % recursively and it assigned an missing, explicitly
                    % return an empty of the correct class. This allows
                    % refreshing existing objects and clearing properties 
                    % if they are no longer set.
                    obj = obj.empty;
                end
            end
        end

        function obj = fromStructOrCell(obj,structOrCell)
            % For all properties in the *class* (not the struct)
            props = properties(obj);
            % But for the number of array elements in the *struct*
            for arrayIndex=1:length(structOrCell)
                % jsondecode may have decoded the response as a struct
                % array if all the elements had the same fields, but if not
                % it might be a cell array of structs. Either way obtain
                % the current scalar struct from the (cell)-array
                if isstruct(structOrCell)
                    curStruct = structOrCell(arrayIndex);
                elseif iscell(structOrCell)
                    curStruct = structOrCell{arrayIndex};
                end
                % For each property
                for pi=1:length(props)
                    propName = props{pi};
                    % Check whether property is also present in struct
                    if isfield(curStruct,propName)
                        % If so, set the property to the struct value
                        obj(arrayIndex).(propName) = curStruct.(propName);
                    else
                        % If the field is not present in the struct,
                        % explicitly set the object property to missing,
                        % this allows the same method to also be used for
                        % refreshing existing objects and not only for
                        % filling in properties in new objects
                        setMissing = true;
                        if isenum(obj(arrayIndex).(propName))
                            setMissing = false;
                        else
                            switch class(obj(arrayIndex).(propName))
                                case {'int64', 'int32', 'int16', 'int8'}
                                    % Do nothing here, as there is no
                                    % missing concept for these types.
                                    setMissing = false;
                                otherwise
                                    % Do nothing, setMissing is true
                            end
                        end
                        if setMissing
                            obj(arrayIndex).(propName) = missing;
                        end
                    end
                end
            end
        end
    end
end