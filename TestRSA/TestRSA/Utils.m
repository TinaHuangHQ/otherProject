//
//  Utils.m
//  TestRSA
//
//  Created by macbook pro on 2020/12/16.
//

#import "Utils.h"
//将可读的16进制串合并成其一半长度的二进制串,"12AB"-->0x12AB
//Convert readable HEX string to BIN string, which only half length of HEX string. "12AB"-->0x12AB
void PubAsc2Bcd(unsigned char *psIn, unsigned int uiLength, unsigned char *psOut){
    unsigned char   tmp;
    unsigned int    i;

    if ((psIn == NULL) || (psOut == NULL)) {
        return;
    }

    for (i = 0; i < uiLength; i += 2) {
        tmp = psIn[i];
        if (tmp > '9'){
            tmp = (unsigned char)toupper((int)tmp) - 'A' + 0x0A;
        }
        else{
            tmp &= 0x0F;
        }
        psOut[i / 2] = (tmp << 4);

        tmp = psIn[i + 1];
        if (tmp > '9') {
            tmp = toupper((char)tmp) - 'A' + 0x0A;
        }
        else {
            tmp &= 0x0F;
        }
        psOut[i / 2] |= tmp;
    }
}

//将二进制源串分解成双倍长度可读的16进制串,0x12AB-->"12AB"
//Convert BIN string to readable HEX string, which have double length of BIN string. 0x12AB-->"12AB"
void PubBcd2Asc(unsigned char *psIn, unsigned int uiLength, unsigned char *psOut)
{
    static const unsigned char ucHexToChar[17] = { "0123456789ABCDEF" };
    unsigned int   uiCnt;

    if ((psIn == NULL) || (psOut == NULL)){
        return;
    }

    for (uiCnt = 0; uiCnt < uiLength; uiCnt++) {

        psOut[2 * uiCnt] = ucHexToChar[(psIn[uiCnt] >> 4)];
        psOut[2 * uiCnt + 1] = ucHexToChar[(psIn[uiCnt] & 0x0F)];
    }
}

@implementation Utils

+ (NSData *) getBcdFromString:(NSString *)string {
    Byte bcd[1024*16] = {0};
    PubAsc2Bcd((unsigned char *)[string UTF8String], (unsigned int)[string length],bcd);
    NSData *bcdData = [[NSData alloc] initWithBytes:bcd length:[string length]/2];
    return bcdData;
}

+ (NSString *) getStringFromBcd:(NSData *)bcd {
    //    Byte *asc = malloc(sizeof(Byte)*[bcd length]*2+1);
    
    Byte asc[1024*16]={0};
    if ([bcd length]*2 > sizeof(asc)) {
        return [NSString stringWithFormat:@""];
    }
    PubBcd2Asc((unsigned char *)[bcd bytes], (unsigned int)[bcd length]*2,asc);
    *(asc+[bcd length]*2) = 0x00;
    NSString *ascString = [NSString stringWithFormat:@"%s",asc];
    //    free(asc);
    return ascString;
}


@end
