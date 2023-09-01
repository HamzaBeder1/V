import math

funcClasses = dict()
funcClasses["trig"] = {"arctan", "hyp","arccos", "arcsin"}
funcClasses["hyperbolic"] = {"sinh", "cosh", "arctanh", "ex", "lnx"}
def CORDIC(x_0, y_0, z_0, theta, iterations, func):
    try:
        if func not in funcClasses["trig"] and func not in funcClasses["hyperbolic"]:
            raise Exception("Not a valid function")
    except Exception as error:
        print("Error:", error)
        return
    x = x_0
    y = y_0
    z = z_0

    x_new = 0
    y_new = 0
    z_new = 0
    m= 1
    start = 0
    if(func in funcClasses["hyperbolic"]):
        m = -1
        start = 1

    for i in range(start, iterations):
        d = -1
        if(func == "arctan" or func == "hyp"):
            if(y < 0):
                d = 1
        elif(func == "arcsin"):
            if(y < theta):
                d = 1
        elif(func == "arccos"):
            if(x < theta):
                d = 1
        elif(func == "sinh" or func == "cosh" or func == "ex"):
            if(z >= 0):
                d = 1
        elif(func == "arctanh" or func == "lnx"):
            if(y<0):
                d = 1
        x_new = x - y *m* d * (2 ** -i)
        y_new = y + x * d * (2 ** -i)
        z_new = z - d * math.atan(2 ** -i)
        x = x_new
        y = y_new
        z = z_new
    if(func == "arctan" or func == "arccos" or func == "arcsin" or func == "arctanh"):
        print(z)
    elif(func == "hyp"):
        print(x)/1.647
    elif(func == "sinh" or func == "cosh"):
        print([x,y])
    elif(func == "ex"):
        print(x+y)
    elif(func == "lnx"):
        print(2*z)

