-- Source: chapters/ch27_composable_design.tex:180

def sanitize (r : RawRow) : ValidRow :=
  { userId := r.userId, amount := r.amountText }

def enrich (r : ValidRow) : EnrichedRow :=
  { userId := r.userId, amount := r.amount, fee := 10 }

def summarize (r : EnrichedRow) : ReportRow :=
  { userId := r.userId, total := r.amount + r.fee }

def pipeline : RawRow -> ReportRow :=
  Function.comp summarize (Function.comp enrich sanitize)

def pipelineExpanded (r : RawRow) : ReportRow :=
  summarize (enrich (sanitize r))
