data "azuread_client_config" "current" {}


resource "azuread_application" "example" {
  display_name   = "DemoAppWithCert"
  owners = [data.azuread_client_config.current.object_id]

  required_resource_access {
    //Microsoft Graph API
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    //User.Read
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }

    //Application.ReadWrite.OwnedBy
    resource_access {
      id   = "18a4783c-866b-4cc7-a460-3d5e5662c884"
      type = "Role"
    }

    //Directory.Read.All
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }
  }

}

resource "tls_private_key" "example" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "example" {
  key_algorithm   = "ECDSA"
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "DemoAppWithCert"
    organization = "MITC"
  }

  validity_period_hours = 48

  allowed_uses = [
    "client_auth",
  ]
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}

resource "azuread_service_principal_certificate" "example" {
  service_principal_id = azuread_service_principal.example.id
  type                 = "AsymmetricX509Cert"
  value                 = tls_self_signed_cert.example.cert_pem
  end_date_relative = "47h"
}

locals {

  pem_public_base64 = base64encode(tls_self_signed_cert.example.cert_pem)
  pem_private_base64 = base64encode(tls_private_key.example.private_key_pem)

}

resource "local_file" "private_key" {
    content  = base64decode(local.pem_private_base64)
    filename = "private_key.pem"
}

resource "local_file" "public_key" {
    content  = base64decode(local.pem_public_base64)
    filename = "public_key.pem"
}
