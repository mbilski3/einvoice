require "einvoice/utils"

require "einvoice/neweb/model/base"
require "einvoice/neweb/model/contact"
require "einvoice/neweb/model/customer_defined"
require "einvoice/neweb/model/invoice_item"
require "einvoice/neweb/model/invoice"
require "einvoice/neweb/model/pre_invoice"
require "einvoice/neweb/model/seller_invoice"

require "einvoice/neweb/result"

module Einvoice
  module Neweb
    class Provider < Einvoice::Provider
      include Einvoice::Utils

      def issue(payload, type: :pre_invoice)
        case options[:type]
        when :pre_invoice
          action = "IN_PreInvoiceS.action"
          invoice = Einvoice::Neweb::Model::PreInvoice.new
        when :seller_invoice
          action = "IN_SellerInvoiceS.action"
          invoice = Einvoice::Neweb::Model::SellerInvoice.new
        else
          # nothing
        end

        invoice.from_json(payload.to_json)

        if invoice.valid?
          response = connection.post do |request|
            request.url options[:url] || endpoint + action
            request.body = {
              storecode: client_id,
              xmldata: encode_xml(wrap(serialize(invoice)))
            }
          end.body

          Einvoice::Neweb::Result.new(response)
        else
          Einvoice::Neweb::Result.new(invoice.errors)
        end
      end
    end
  end
end
