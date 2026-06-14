-- Source: chapters/ch27_composable_design.tex:203

theorem pipeline_same_as_expanded (r : RawRow) :
    pipeline r = pipelineExpanded r := by
  rfl

def pipelineWithIdentity (r : RawRow) : ReportRow :=
  summarize ((fun x => x) (enrich (sanitize r)))

theorem identity_step_removed (r : RawRow) :
    pipelineWithIdentity r = pipeline r := by
  rfl

theorem pipeline_assoc (r : RawRow) :
    (Function.comp summarize (Function.comp enrich sanitize)) r =
      (Function.comp (Function.comp summarize enrich) sanitize) r := by
  rfl
