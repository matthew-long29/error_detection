import random
import crcmod

NUM_PACKETS = 100000
PAYLOAD_SIZE = 10
PACKET_BITS = (PAYLOAD_SIZE + 2) * 8

ERROR_RATE = 0.1 #Actually 1e-3, add higher rate to test more errors 
NUM_ERRORS = 3 #Vary the max number of errors per packet

POLYNOMIAL = 0x11021 #CRCmod requires explicity x^16 term, which is why polynomial is 0x11021 instead of 0x1021
INIT = 0x0000

crc16 = crcmod.mkCrcFun(POLYNOMIAL, rev=False, initCrc=INIT, xorOut=0x0000)

with open("packets.data", "w") as f, open("expected_results.data", "w") as f2:

    for _ in range(NUM_PACKETS):

        payload = bytes(random.randint(0,255) for _ in range(PAYLOAD_SIZE))

        payload_int = int.from_bytes(payload, 'big')
        crc_val = crc16(payload)

        packet = (payload_int << 16) | crc_val

        if random.random() < ERROR_RATE:

            f2.write("1\n")

            flipped_index = []
            for _ in range(NUM_ERRORS):
                bit_index = random.randint(0, PACKET_BITS - 1)
                while (bit_index in flipped_index): #Make sure that the same bit isnt flipped multiple times
                    bit_index = random.randint(0, PACKET_BITS - 1)
                flipped_index.append(bit_index)

                packet ^= (1 << bit_index)

        else:
            f2.write("0\n")

        f.write(f"{packet:0{(PAYLOAD_SIZE+2)*2}X}\n")


