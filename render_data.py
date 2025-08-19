filebuffer = ""
with open("data.csv", "r") as file:
    for line in file:
        line = line.strip()
        line = line.split(", ")
        spi_map = line[0]
        spi_data = hex(int(line[1]))
        filebuffer = filebuffer + (str(spi_map) + ", " + str(spi_data) + "\n")

f = open("output.csv", "w")
f.write(filebuffer)
f.close()