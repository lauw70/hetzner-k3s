require "json"
require "./public_net"
require "./network_interface"

class Hetzner::Instance
  include JSON::Serializable

  property id : Int32
  property name : String
  property status : String
  getter public_net : PublicNet?
  getter private_net : Array(Hetzner::NetworkInterface)?

  def public_ip_address
    public_net.try(&.ipv4).try(&.ip)
  end

  def private_ip_address
    net = private_net

    if net.try(&.empty?)
      public_ip_address
    elsif net
      net[0].ip
    end
  end

  def host_ip_address
    if public_ip_address.nil?
      private_ip_address
    else
      public_ip_address
    end
  end

  def master?
    /-master\d+/ =~ name
  end
end
