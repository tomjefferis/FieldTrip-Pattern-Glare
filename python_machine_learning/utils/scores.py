import numpy as np
import scipy


def getscore(factor):
    if 'headache' in factor:

        return [
            -0.22667,
            -0.05198,
            -0.72116,
            0.53139,
            1.72021,
            -1.17636,
            -0.79706,
            0.19942,
            -0.6924,
            -0.35826,
            -0.58533,
            2.04136,
            -0.26573,
            1.30963,
            3.4497,
            0.00172,
            -0.15026,
            0.00001,
            -0.55639,
            -0.41626,
            1.14373,
            -0.56513,
            -0.72755,
            -0.43472,
            -0.69897,
            -1.34952,
            1.40986,
            0.36296,
            0.04162,
            -0.4697,
            -0.70362,
            -0.73219,
            -0.88081,
            -0.79623,
            -0.75114,
            0.09594,
            1.22665,
            -0.3365,
            1.07651,
            -0.16678,
        ]
    elif 'none' in factor:
        return [
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
            1,
        ]
    elif 'visual-stress' in factor:
        return [
            0.3227,
            -0.10861,
            -0.51018,
            1.1336,
            -0.63947,
            -1.21472,
            -0.33005,
            0.75238,
            -0.39025,
            -0.72205,
            -0.76904,
            -1.06297,
            -0.89853,
            -1.46715,
            -1.87343,
            -1.19871,
            0.15415,
            -0.20117,
            -0.43427,
            0.5867,
            1.0008,
            -0.11689,
            1.72091,
            0.14105,
            0.62214,
            -0.74829,
            2.02421,
            0.67386,
            -0.02367,
            0.03638,
            0.6996,
            -0.29977,
            -0.64998,
            0.02624,
            -0.82177,
            -0.42512,
            0.79861,
            -0.58832,
            2.33323,
            2.26667,
        ]
    elif 'discomfort' in factor:
        return [
            -0.264,
            0.4459,
            -0.49781,
            1.77666,
            -0.55638,
            0.87174,
            -0.68504,
            0.92835,
            -0.80581,
            -0.87505,
            0.39111,
            -0.76054,
            -0.68987,
            1.60776,
            -0.19637,
            1.13956,
            1.53606,
            -0.1005,
            -0.08254,
            0.12186,
            0.08428,
            0.61663,
            -1.47958,
            2.28422,
            -0.80891,
            -0.55738,
            0.2238,
            -0.93291,
            0.3791,
            -0.63074,
            2.14683,
            -1.49948,
            1.21954,
            -0.79734,
            -0.51303,
            -1.0687,
            -0.61345,
            -1.02592,
            -0.87653,
            0.444,
        ]


def matchscores(scores, order):
    # return items in scores in the order of order
    return [scores[i] for i in order]

def func(x,a,b,c):
    return a*(b**x)+c

def multiplyscores(score, data):
    # map length scores to exponentail decrease 2.72,2.65,1
    fits = [2.72, 2.65, 1]
    # get midpoint of data
    midpoint = len(data) // 2
    # get length of data
    length = len(data)
    # fit line to fits
    #fitline = np.polyfit([0, midpoint, length],fits, 2)
    fitline2 = scipy.optimize.curve_fit(func,  [0,midpoint,length],  fits, p0=[-0.003,1,2.7],maxfev=50000)
    # multiply scores by fitline
    sc = []
    for i in range(len(data)):
        val = func(i,fitline2[0][0],fitline2[0][1],fitline2[0][2])
        sc.append(round(score * val,4))
    return sc

def getPartitionsScores(order, factor, type):

    if type == 'habituation':
        fits = [2.72, 2.65, 1]
    else:
        fits = [1, 2.65, 2.72]

    # get scores corresponding to factor
    scores = getscore(factor)
    # match scores to order
    scores = matchscores(scores, order)
    return(orthogonolize([scores*fits[0], scores*fits[1], scores*fits[2]]))



def orthogonolize(scores):
    # orthogonalize scores
    Q, R = gramschmidt(scores)
    # return orthogonalized scores
    return Q


def normalize(scores):
    # normalize scores
    return [score / sum(scores) for score in scores]


def gramschmidt(A):
    return np.linalg.qr(A)
