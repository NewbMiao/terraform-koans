%{ if ns == "*" }
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${role}-cluster-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ${role_ref}
subjects:
- kind: User
  name: ${role}
  apiGroup: rbac.authorization.k8s.io
%{ else }
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${role}-${ns}-binding
  namespace: ${ns}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ${role_ref}
subjects:
- kind: User
  name: ${role}
  apiGroup: rbac.authorization.k8s.io
%{ endif }
