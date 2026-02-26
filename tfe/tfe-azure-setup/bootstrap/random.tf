# ========================================
# Random Resources
# ========================================
# Purpose: Generate random values for unique resource names
# ========================================

resource "random_integer" "storage_suffix" {
  min = 1000
  max = 9999
}