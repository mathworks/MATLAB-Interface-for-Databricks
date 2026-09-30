function T = multiTypeTable()
    % multiTypeTable Create table with many data types and structure
    
    % Copyright MathWorks Inc. 2020
    
    % Reinstate int8 when byte is implemented.
    % Reinstate int16 when short is implemented.
    
    TemplateS1.A1 = double(1);
    TemplateS1.B1 = single(2);
%     TemplateS1.C1 = int8(3);
%     TemplateS1.D1 = int16(4);
    TemplateS1.E1 = int32(5);
    TemplateS1.F1 = int64(6);
    %     TemplateS1.G1 = uint8(7);
    %     TemplateS1.H1 = uint16(8);
    %     TemplateS1.I1 = uint32(9);
    %     TemplateS1.J1 = uint64(10);
    TemplateS1.K1 = true;
%     TemplateS1.L1 = SlDemoSign.Positive;
    TemplateS1.A2 = [double(1) double(pi) eps('double') realmin('double') realmax('double')];
    TemplateS1.B2 = [single(2) single(pi) eps('single') realmin('single') realmax('single')];
%     TemplateS1.C2 = [int8(3)   intmin('int8')   intmax('int8')];
%     TemplateS1.D2 = [int16(4)  intmin('int16')  intmax('int16')];
    TemplateS1.E2 = [int32(5)  intmin('int32')  intmax('int32')];
    TemplateS1.F2 = [int64(6) intmin("int64") intmax("int64")];
    %     TemplateS1.G2 = [uint8(7)  intmin('uint8')  intmax('uint8')];
    %     TemplateS1.H2 = [uint16(8) intmin('uint16') intmax('uint16')];
    %     TemplateS1.I2 = [uint32(9) intmin('uint32') intmax('uint32')];
    %     TemplateS1.J2 = [uint64(10) intmin("uint64") intmax("uint64")];
    TemplateS1.K2 = [false true];
%     TemplateS1.L2 = [SlDemoSign.Negative SlDemoSign.Positive];
    
    Template    = TemplateS1;
    Template.S1 = TemplateS1;
    Template.S2 = repmat(TemplateS1,1,2);
    
    S = repmat(Template, 5,1);
    
    T = struct2table(S);
    
end