@keras_export('keras.activations.spocuc1')
def spocuc1(x, alpha=2.1959, beta=0.6641):
  xmasbeta = x + beta
  rxmasbeta = K.pow(xmasbeta, 8) - 2 * K.pow(xmasbeta, 7) + 2 * K.pow(xmasbeta, 3)
  hxmasbeta = K.switch(K.greater_equal(xmasbeta, 1), K.ones_like(xmasbeta), 
                       K.switch(K.less(xmasbeta, 0), K.zeros_like(xmasbeta), rxmasbeta))
  if beta >= 1: hbeta = 1
  elif beta < 0: hbeta = 0
  else: hbeta = beta ** 8 - 2 * beta ** 7 + 2 * beta ** 3

  return alpha * (hxmasbeta -  hbeta)


@keras_export('keras.activations.spocucInf')
def spocucInf(x, alpha=3.0937, beta=0.6653, gamma=4.437):
  xmasbeta = x/gamma + beta
  rxmasbeta = K.pow(xmasbeta, 8) - 2 * K.pow(xmasbeta, 7) + 2 * K.pow(xmasbeta, 3)
  hxmasbeta = K.switch(K.less(xmasbeta, 0), K.zeros_like(xmasbeta), rxmasbeta)

  if beta < 0: hbeta = 0
  else: hbeta = beta ** 8 - 2 * beta ** 7 + 2 * beta ** 3

  return alpha * (hxmasbeta -  hbeta)