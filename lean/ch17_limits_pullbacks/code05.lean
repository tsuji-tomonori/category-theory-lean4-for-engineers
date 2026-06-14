-- Source: chapters/ch17_limits_pullbacks.tex:291

structure Shipment where
  orderId : Nat
  userId : UserId
  delivered : Bool
deriving Repr, DecidableEq

def shipmentMatchesOrder (s : Shipment) (o : Order) : Prop :=
  s.userId = o.userId /\ s.orderId = o.orderId

structure OrderShipment where
  order : Order
  shipment : Shipment
  matched : shipmentMatchesOrder shipment order

theorem orderShipment_userId_eq (os : OrderShipment) :
    os.shipment.userId = os.order.userId :=
  os.matched.left

theorem orderShipment_orderId_eq (os : OrderShipment) :
    os.shipment.orderId = os.order.orderId :=
  os.matched.right


def exampleProfile : Profile :=
  { userId := 10, displayName := "Ada" }

def exampleOrder : Order :=
  { orderId := 500, userId := 10, total := 1200 }

def exampleJoined : ProfileOrder :=
  joinProfileOrder exampleProfile exampleOrder rfl

#eval exampleJoined.profile.displayName
#eval exampleJoined.order.total

end Ch17
