# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "group_key_id" {
  description = "(Required) The ID of the entity. For Google-managed entities, the id must be the email address of an existing group or user. For external-identity-mapped entities, the id must be a string conforming to the Identity Source's requirements. Must be unique within a namespace."
  type        = string
}

variable "parent" {
  description = "(Required) The resource name of the entity under which this Group resides in the Cloud Identity resource hierarchy. Must be of the form identitysources/{identity_source_id} for external-identity-mapped groups or customers/{customer_id} for Google Groups."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "labels" {
  description = "(Optional) The labels that apply to the Group. Must not contain more than one entry. Must contain the entry 'cloudidentity.googleapis.com/groups.discussion_forum': '' if the Group is a Google Group or 'system/groups/external': '' if the Group is an external-identity-mapped group."
  type        = map(string)
  default     = { "cloudidentity.googleapis.com/groups.discussion_forum" : "" }
}

variable "display_name" {
  description = "(Optional) The display name of the Group."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) An extended description to help users determine the purpose of a Group. Must not be longer than 4,096 characters."
  type        = string
  default     = null
}

variable "initial_group_config" {
  description = "(Optional) The initial configuration options for creating a Group. Default value is EMPTY. Possible values are INITIAL_GROUP_CONFIG_UNSPECIFIED, WITH_INITIAL_OWNER, and EMPTY."
  type        = string
  default     = "EMPTY"

  validation {
    condition     = contains(["WITH_INITIAL_OWNER", "EMPTY", "INITIAL_GROUP_CONFIG_UNSPECIFIED"], var.initial_group_config)
    error_message = "The value must only be one of these valid values: WITH_INITIAL_OWNER, INITIAL_GROUP_CONFIG_UNSPECIFIED and EMPTY."
  }
}

variable "group_key_namespace" {
  description = "(Optional) The namespace in which the entity exists. If not specified, the EntityKey represents a Google-managed entity such as a Google user or a Google Group. If specified, the EntityKey represents an external-identity-mapped group. The namespace must correspond to an identity source created in Admin Console and must be in the form of `identitysources/{identity_source_id}`."
  type        = string
  default     = null
}

variable "memberships" {
  description = "(Optional) A list of memberships (id, roles) to get attached to the group resource created."
  type        = any
  default     = []

  validation {
    condition     = length(var.memberships) == 0 ? true : alltrue([for x in var.memberships : x.id != null && x.id != "" ? true : false])
    error_message = "All memberships must have an id defined."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ---------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_timeouts" {
  description = "(Optional) A map of timeout objects that is keyed by Terraform resource name defining timeouts for `create`, `update` and `delete` Terraform operations."
  type        = any
  default     = null
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
