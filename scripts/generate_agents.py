for i in range(10):
    for j in range(10):
        print("agent[{}].x = {}".format(10 * i + j, i * 102 + 25 )) # i, i // 10
        print("agent[{}].y = {}".format(10 * i + j, j * 102 + 25 )) # i, i % 10
        print("agent[{}].orientation = {}".format(10 * i + j, 90))
        print()
