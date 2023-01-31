require 'base64'
require 'openssl'

require "einvoice/utils"

require "einvoice/tradevan/model/base"
require "einvoice/tradevan/model/issue_data"
require "einvoice/tradevan/model/issue_item"
require "einvoice/tradevan/model/void_data"

require "einvoice/tradevan/result"

module Einvoice
  module Tradevan
    class Provider < Einvoice::Provider
      def issue(payload, options = {})
        issue_data = Einvoice::Tradevan::Model::IssueData.new
        issue_data.from_json(payload.to_json)

        if issue_data.valid?
          response = connection.post do |request|
            request.url endpoint_url + "/DEFAULTAPI/cbepost/issueLong"
            request.params[:v] = merged_params(issueData: issue_data.payload)
          end.body

          Einvoice::Tradevan::Result.new(response)
        else
          Einvoice::Tradevan::Result.new(issue_data.errors)
        end
      end

      def cancel(payload, options = {})
        void_data = Einvoice::Tradevan::Model::VoidData.new
        void_data.from_json(payload.to_json)

        if void_data.valid?
          response = connection.post do |request|
            request.url endpoint_url + "/DEFAULTAPI/cbepost/cancelLong"
            request.params[:v] = merged_params(voidData: void_data.payload)
          end.body

          Einvoice::Tradevan::Result.new(response)
        else
          Einvoice::Tradevan::Result.new(void_data.errors)
        end
      end

      def search_invoice_by_member_id(payload, options = {})
        response = connection.get do |request|
          request.url endpoint_url + "/DEFAULTAPI/get/searchInvoiceByMemberId"
          request.params[:v] = merged_params(payload)
        end.body

        Einvoice::Tradevan::Result.new(response)
      end

      def search_invoice_detail(invoice_number)
        response = connection.get do |request|
          request.url endpoint_url + "/DEFAULTAPI/get/searchInvoiceDetail"
          request.params[:v] = merged_params(invoiceNumber: invoice_number)
        end.body

        Einvoice::Tradevan::Result.new(response)
      end

      def search_invoice_by_transaction_number(payload, options = {})
        response = connection.get do |request|
          request.url endpoint_url + "/DEFAULTAPI/get/searchInvoiceInfoByTransactionnumber"
          request.params[:v] = merged_params(payload.slice(:companyUn, :orgId, :transactionNumber))
        end.body

        Einvoice::Tradevan::Result.new(response)
      end

      def send_card_info_to_cust(payload, options = {})
        response = connection.get do |request|
          request.url endpoint_url + "/DEFAULTAPI/get/sendCardInfotoCust"
          request.params[:v] = merged_params(payload)
        end.body

        Einvoice::Tradevan::Result.new(response)
      end

      def get_invoice_mark_info(payload, options = {})
        response = connection.get do |request|
          request.url endpoint_url + "/DEFAULTAPI/get/getInvoiceMarkInfo"
          request.params[:v] = merged_params(payload)
        end.body

        Einvoice::Tradevan::Result.new(response)
      end

      def get_donate_unit_list(companyUn, options = {})
        response = connection.get do |request|
          request.url endpoint_url + "/DEFAULTAPI/get/getDonateUnitList"
          request.params[:v] = merged_params(companyUn: companyUn)
        end.body

        Einvoice::Tradevan::Result.new(response)
      end

      def get_invoice_content(payload, options = {})
        response = connection.get do |request|
          request.url endpoint_url + "/DEFAULTAPI/get/getInvoiceContent"
          request.params[:v] = merged_params(payload)
        end.body

        Einvoice::Tradevan::Result.new(response)
      end

      private

      def merged_params(params)
        JSON({ acnt: client_id, acntp: client_secret }.merge(params))
      end
    end
  end
end
