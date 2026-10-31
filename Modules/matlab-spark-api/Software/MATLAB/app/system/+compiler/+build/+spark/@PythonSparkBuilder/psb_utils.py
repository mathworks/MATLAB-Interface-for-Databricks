

def __getConversionIndex(value):
    """Calculate an index (enum), that is used for deciding how
    to convert this input value. The index is used in the
    __convertWithIndex function."""
    if isinstance(value, numpy.ndarray):
        if (value.ndim == 2):
            convIndex = 2
        elif (value.ndim ==1):
            convIndex = 1
        else:
            raise Exception("Only ndarrays of dimensions 1 or 2 are supported")
    else:
        convIndex = 0
    return convIndex

def __convertWithIndex(value, convIndex):
    """Conert an input value with the help of a conversion index.
    The index is calculated with the __getConversionIndex function."""
    if (convIndex == 1):
        return value.tolist()
    elif (convIndex == 2):
        return value[0].tolist()

    # Default case is to return value
    return value
