-- Source: chapters/ch05_category.tex:310

-- 例を小さくするため、文字列の長さをユーザーIDの代わりに使う。
def parseUserId (s : String) : Nat :=
  s.length

def fetchUserName (id : Nat) : String :=
  "user-" ++ toString id

def renderGreeting (name : String) : String :=
  "hello, " ++ name

-- 前半を後でまとめる見方。
def pipelineLeft : String -> String :=
  comp (comp renderGreeting fetchUserName) parseUserId

-- 後半を先にまとめる見方。
def pipelineRight : String -> String :=
  comp renderGreeting (comp fetchUserName parseUserId)

#eval pipelineLeft "abc"
