

#include <inttypes.h>
#include <string.h>
#include <math.h>

#include "mex.h"
#include "matrix.h"

#define WHITESPACE 64
#define EQUALS 65
#define INVALID 66

static const unsigned char d[] = {
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 64, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 62, 66, 66, 66, 63, 52, 53,
    54, 55, 56, 57, 58, 59, 60, 61, 66, 66, 66, 65, 66, 66, 66, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 66, 66, 66, 66, 66, 66, 26, 27, 28,
    29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66,
    66, 66, 66, 66, 66, 66};

static void usage();
static void usageError(const char *msg);
static int base64decode(char *in, size_t inLen, unsigned char *out, size_t *outLen);
static int base64encode(const void *data_buf, size_t dataLength, char *result, size_t resultSize);

static void usage()
{
    mexPrintf("Usage:\n");
    mexPrintf("\tdecodedArray = mxBase64('decode', byteArray)\n");
    mexPrintf("\tencodedArray = mxBase64('encode', byteArray)\n");
    mexPrintf("The byteArray in both cases should be of type uint8\n");
}

static void usageError(const char *msg)
{
    usage();
    mexErrMsgTxt(msg);
}

static size_t decodedLength(size_t inputLength)
{
    /* The decoded length should always be a multiple of 4 */
    return inputLength / 4 * 3;
}

static size_t encodedLength(size_t inputLength)
{
    /*
     */
    // int rest = inputLength % 3;
    // mexPrintf("inputLength: %d rest: %d ", inputLength, rest);
    // if (rest == 0) {
    //     len = inputLength/3*4;
    // } else {
    //     len = (inputLength-rest)/3*4 + 4 - rest;
    // }
    //     mexPrintf("len: %d\n", len);
    size_t txtLen = inputLength;
    size_t L = (size_t)floor(((double)txtLen) * 4.0 / 3.0);
    int rest = txtLen % 3;
    if (rest > 0)
    {
        L = L + 4 - rest;
    }
    return (L+1); // Add one for '\0'
}

void mexFunction(int nlhs, mxArray **plhs, int nrhs, const mxArray **prhs)
{
/*
     * Arguments:
     * action: 'encode' or 'decode'
     * bytearray: uint8 array
     * Output: 
     * Encoded/decoded array
     */
#define ACTION (prhs[0])
#define BYTEARRAY (prhs[1])

#define OUTARRAY (plhs[0])
    char action[10];
    size_t N;
    if (nrhs != 2)
    {
        usageError("Wrong number of arguments\n");
    }
    if ((mxGetClassID(ACTION) != mxCHAR_CLASS) || (mxGetClassID(BYTEARRAY) != mxUINT8_CLASS))
    {
        usageError("Wrong type of arguments");
    }

    if (mxGetString(ACTION, action, 10))
    {
        usageError("Wrong action string\n");
    }

    N = mxGetNumberOfElements(BYTEARRAY);
    if (strcmp(action, "encode") == 0)
    {
        const void *data_buf = (const void*) mxGetUint8s(BYTEARRAY);
        size_t M = encodedLength(N);
        char_T * result = mxCalloc(M, sizeof(char_T));
        //mexPrintf("N, M == %d, %d\n", N, M);
        int res;
        if (res = base64encode(data_buf, N, result, M)) {
            mexPrintf("res == %d\n", res);
            mexErrMsgTxt("Problem encoding stuff");
		}
		else {
			OUTARRAY = mxCreateString(result);
		}

        return;
    }
    if (strcmp(action, "decode") == 0)
    {
		size_t outLen = decodedLength(N);
		unsigned char* outbuf = mxCalloc(outLen, sizeof(unsigned char));
		char* inbuf = (char*)mxGetUint8s(BYTEARRAY);
		if (base64decode((char *)inbuf, N, outbuf, &outLen)) {
			mexErrMsgTxt("Bad return value from decode\n");
		}
		OUTARRAY = mxCreateNumericMatrix(1, outLen, mxUINT8_CLASS, mxREAL);
		memcpy(mxGetUint8s(OUTARRAY), outbuf, outLen);
		mxFree(outbuf);
        return;
    }

    usageError("Only allowed commands are 'encode' and 'decode'\n");

#undef ACTION
#undef BYTEARRAY
#undef OUTARRAY
}

static int base64decode(char *in, size_t inLen, unsigned char *out, size_t *outLen)
{
    char *end = in + inLen;
    char iter = 0;
    uint32_t buf = 0;
    size_t len = 0;

    while (in < end)
    {
        unsigned char c = d[*in++];

        switch (c)
        {
        case WHITESPACE:
            continue; /* skip whitespace */
        case INVALID:
            return 1; /* invalid input, return error */
        case EQUALS:  /* pad character, end of data */
            in = end;
            continue;
        default:
            buf = buf << 6 | c;
            iter++; // increment the number of iteration
            /* If the buffer is full, split it into bytes */
            if (iter == 4)
            {
                if ((len += 3) > *outLen)
                    return 1; /* buffer overflow */
                *(out++) = (buf >> 16) & 255;
                *(out++) = (buf >> 8) & 255;
                *(out++) = buf & 255;
                buf = 0;
                iter = 0;
            }
        }
    }

    if (iter == 3)
    {
        if ((len += 2) > *outLen)
            return 1; /* buffer overflow */
        *(out++) = (buf >> 10) & 255;
        *(out++) = (buf >> 2) & 255;
    }
    else if (iter == 2)
    {
        if (++len > *outLen)
            return 1; /* buffer overflow */
        *(out++) = (buf >> 4) & 255;
    }

    *outLen = len; /* modify to reflect the actual output size */
    return 0;
}

static int base64encode(const void *data_buf, size_t dataLength, char *result, size_t resultSize)
{
    const char base64chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const uint8_t *data = (const uint8_t *)data_buf;
    size_t resultIndex = 0;
    size_t x;
    uint32_t n = 0;
    int padCount = dataLength % 3;
    uint8_t n0, n1, n2, n3;

    /* increment over the length of the string, three characters at a time */
    for (x = 0; x < dataLength; x += 3)
    {
        /* these three 8-bit (ASCII) characters become one 24-bit number */
        n = ((uint32_t)data[x]) << 16; //parenthesis needed, compiler depending on flags can do the shifting before conversion to uint32_t, resulting to 0

        if ((x + 1) < dataLength)
            n += ((uint32_t)data[x + 1]) << 8; //parenthesis needed, compiler depending on flags can do the shifting before conversion to uint32_t, resulting to 0

        if ((x + 2) < dataLength)
            n += data[x + 2];

        /* this 24-bit number gets separated into four 6-bit numbers */
        n0 = (uint8_t)(n >> 18) & 63;
        n1 = (uint8_t)(n >> 12) & 63;
        n2 = (uint8_t)(n >> 6) & 63;
        n3 = (uint8_t)n & 63;

        /*
       * if we have one byte available, then its encoding is spread
       * out over two characters
       */
        if (resultIndex >= resultSize)
            return 1; /* indicate failure: buffer too small */
        result[resultIndex++] = base64chars[n0];
        if (resultIndex >= resultSize)
            return 1; /* indicate failure: buffer too small */
        result[resultIndex++] = base64chars[n1];

        /*
       * if we have only two bytes available, then their encoding is
       * spread out over three chars
       */
        if ((x + 1) < dataLength)
        {
            if (resultIndex >= resultSize)
                return 1; /* indicate failure: buffer too small */
            result[resultIndex++] = base64chars[n2];
        }

        /*
       * if we have all three bytes available, then their encoding is spread
       * out over four characters
       */
        if ((x + 2) < dataLength)
        {
            if (resultIndex >= resultSize)
                return 1; /* indicate failure: buffer too small */
            result[resultIndex++] = base64chars[n3];
        }
    }

    /*
    * create and add padding that is required if we did not have a multiple of 3
    * number of characters available
    */
    if (padCount > 0)
    {
        for (; padCount < 3; padCount++)
        {
            if (resultIndex >= resultSize)
                return 1; /* indicate failure: buffer too small */
            result[resultIndex++] = '=';
        }
    }
    if (resultIndex >= resultSize)
        return 1; /* indicate failure: buffer too small */
    result[resultIndex] = 0;
    return 0; /* indicate success */
}
