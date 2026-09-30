
def dbgvar(name, value, listIgnoreLimit=0, indentDepth=1):
    indent = ' ' * 2 * indentDepth

    print(f'{indent} type({name})', type(value))
    if isinstance(value, list):
        print(f'{indent} len({name})', len(value))
        if (listIgnoreLimit > 0):
            L0 = value[0]
            dbgvar(f'{name}[0]', value[0], listIgnoreLimit=listIgnoreLimit-1, indentDepth=indentDepth+1)
        else:
            print(f'{indent} {name}', value)    
            i = 0
            while i < len(value):
                LE = value[i]
                dbgvar(f'{name}[{i}]', LE, indentDepth=indentDepth+1)
                i += 1
    elif isinstance(value, numpy.ndarray):
        print(f'{indent} {name}.ndim', value.ndim)
    else:
        print(f'{indent} {name}', value)    


