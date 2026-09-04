project_name: "marketing_spoke"

# ==============================================================================
# HUB & SPOKE MANIFEST: Project Import Definition
# ==============================================================================
# Defines the dependency on the central governed Hub project.
# ==============================================================================

remote_dependency: thelook-antigravity {
  url: "git@github.com:sam-pitcher/thelook-antigravity.git"
  ref: "master" # Pin to master or specific tag release (e.g., 'v1.0.0')
}

# For single-instance local multi-project setups:
# local_dependency: {
#   project: "thelook-antigravity"
# }
