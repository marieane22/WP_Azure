resource "azurerm_lb" "wordpress" {
  name                = "wordpress-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.wordpress.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.wordpress.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.wordpress.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "wordpress" {
  resource_group_name = azurerm_resource_group.wordpress.name
  loadbalancer_id     = azurerm_lb.wordpress.id
  name                = "ssh-running-probe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = azurerm_resource_group.wordpress.name
  loadbalancer_id                = azurerm_lb.wordpress.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.wordpress.id
}

resource "azurerm_linux_virtual_machine_scale_set" "wordpress" {
  name                            = "vmscaleset"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.wordpress.name
  sku                             = "Standard_DS1_v2"
  instances                       = 2
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  # custom_data                     = filebase64("/home/ec2-user/wordpress-terraform-azure/wordpress.sh")
  custom_data = " AAAAB3NzaC1yc2EAAAADAQABAAABAQDkIXx2tfKUGDI2ZCBny8qUM1ihOLWhD7Omn/TGPi+AXX07ihr5nMs6jGfEJPDsm4P1UhFmp/t1CC6JiAllfnfHZLPHo+8Vc03yBQ/FTCFBhnBW+u4xDKCryqRba8flv0XsLm+YPhH4COO9bIu9R/fGWaCUr6/dCqOoELsa5MI0wEXXl31EMSoI4RBrPwOl1Cwfd2CV0T1p5iYSEsHwoeB3RjNCx2Zg9i4ntKypXw6wuJvHvny8twAkOFW/qAXre2corYxvRlSMXSHCPRzfU4u0t5jH/jajWA+kG0GBzB00Fc7AdyuNljVLDEg3GCcd98TGKZ5aYYEgfNZL/5IQ3afp ana@cc-4bfb66c5-7878c6f9dd-dnzsd"

 source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "NetworkInterface"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = azurerm_subnet.private1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      primary                                = true
    }
  }

  tags = var.tags
}
