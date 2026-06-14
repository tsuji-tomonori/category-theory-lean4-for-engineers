-- Source: chapters/ch15_function_extensionality.tex:293

def addDefaultHeader
    (client : Request → Response) : Request → Response :=
  fun r => client r

def recordMetrics
    (client : Request → Response) : Request → Response :=
  fun r => client r

theorem wrapper_order_eq (client : Request → Response) :
    addDefaultHeader (recordMetrics client)
      = recordMetrics (addDefaultHeader client) := by
  funext r
  rfl
