class VendorXyzWrapper::Order
  include Virtus.model

  attribute :id, String
  attribute :status, String
end
