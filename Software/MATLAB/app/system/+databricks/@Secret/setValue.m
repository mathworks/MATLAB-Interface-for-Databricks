function setValue(obj, value)
% SETVALUE Sets a Secret object secret value
% This method permits the secret value property of the Secret object to have
% attributes hidden and private to limit the potential for accidental
% disclosure of the value e.g. via log files. Variables holding the secret value
% should be cleared when no longer needed.

%  (c) 2020 The MathWorks, Inc.

obj.value = value;

end
