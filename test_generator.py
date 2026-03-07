import random

NUM_PACKETS = 10000
PAYLOAD_SIZE = 10
ERROR_RATE = 0.1

POLYNOMIAL = 0x1021
INIT = 0x000
def crc16(data):
    crc = INIT
    for byte in data:
        crc ^= (byte << 8)

        for _ in range(8):
            if crc & 0x8000:
                crc = ((crc << 1) ^ POLYNOMIAL) & 0xFFFF
            else:
                crc = (crc << 1) & 0xFFFF

    return crc


with open ("packets.data", "w") as f, open("expected_results.data", 'w') as f2:

    for i in range (NUM_PACKETS):
        payload = [random.randint(0,255) for j in range(PAYLOAD_SIZE)]
        crc = crc16(bytes(payload))

        crc_h = (crc >> 8) & 0xFF #Get upper byte
        crc_l = crc & 0xFF #Get lower byte

        packet = payload + [crc_h, crc_l]

        #Randomly inject error
        if random.random() < ERROR_RATE:
            byte_index = random.randint(0, len(packet) - 1)
            bit = 1 << random.randint(0, 7)
            packet[byte_index] ^= bit
            f2.write("1\n")
        else:
            f2.write("0\n")

        f.write("".join(f"{b:02X}" for b in packet) + "\n")


