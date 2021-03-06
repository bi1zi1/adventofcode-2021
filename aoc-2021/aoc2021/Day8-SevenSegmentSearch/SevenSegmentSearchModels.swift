import Foundation

let segmentNumberBinaryMap = [
    0: 0b1110111,
    1: 0b0010010,
    2: 0b1011101,
    3: 0b1011011,
    4: 0b0111010,
    5: 0b1101011,
    6: 0b1101111,
    7: 0b1010010,
    8: 0b1111111,
    9: 0b1111011,
]

let binaryToNumberMap = [
    0b1110111: 0,
    0b0010010: 1,
    0b1011101: 2,
    0b1011011: 3,
    0b0111010: 4,
    0b1101011: 5,
    0b1101111: 6,
    0b1010010: 7,
    0b1111111: 8,
    0b1111011: 9,
]


let lengthToValuesMap = [
    2: [0b0010010], // 1
    3: [0b1010010], // 7
    4: [0b0111010], // 4
    5: [0b1011101, 0b1011011, 0b1101011,], // 2, 3, 5
    6: [0b1110111, 0b1101111, 0b1111011,], // 0, 6, 9
    7: [0b1111111], // 8
]

let lengthToWeightMap = [
    2: [
        0b0010000,
        0b0000010,
    ], // 1
    3: [
        0b1000000,
        0b0010000,
        0b0000010,
    ], // 7
    4: [
        0b0100000,
        0b0010000,
        0b0001000,
        0b0000010,
    ], // 4
    5: [
        0b1000000,
        0b0100000,
        0b0010000,
        0b0001000,
        0b0000100,
        0b0000010,
        0b0000001,
    ], // 2, 3, 5
    6: [
        0b1000000,
        0b0100000,
        0b0010000,
        0b0001000,
        0b0000100,
        0b0000010,
        0b0000001,
    ], // 0, 6, 9
    7: [
        0b1000000,
        0b0100000,
        0b0010000,
        0b0001000,
        0b0000100,
        0b0000010,
        0b0000001,
       ], // 8
]

// 2 bit sum
//1: 0b0010010,

// 3 bit sum
//7: 0b1010010,

// 4 bit sum
//4: 0b0111010,

// 5 bit sum
//2: 0b1011101,
//3: 0b1011011,
//5: 0b1101011,

// 6 bit sum
//0: 0b1110111,
//6: 0b1101111,
//9: 0b1111011,

// 7 bit sum
//8: 0b1111111,
