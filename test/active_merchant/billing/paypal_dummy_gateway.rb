require 'active_merchant'

# extends BogusGateway to support recurring billing
module ActiveMerchant
  module Billing
    class PaypalDummyGateway < BogusGateway
      attr_reader :profiles

      def get_profile_id
        return (0...8).map{ (0..9).to_a[rand(9)].to_s }.join
      end

      def profiles
        @profiles ||= {}
      end

      def recurring(amount, credit_card_or_reference, options = {})
        profile_id = get_profile_id
        self.profiles[profile_id] = profile_details_from_options(options)

        money = amount(money)
        case normalize(credit_card_or_reference)
        when '1'
          Response.new(true, SUCCESS_MESSAGE, {:profile_id => profile_id}, :test => true)
        when '2'
          Response.new(false, FAILURE_MESSAGE, {:error => FAILURE_MESSAGE },:test => true)
        else
          raise Error, ERROR_MESSAGE
        end
      end

      def update_recurring(options={})
        credit_card_or_reference = options.delete(:credit_card)
        case normalize(credit_card_or_reference)
        when '1'
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money}, :test => true)
        when '2'
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money, :error => FAILURE_MESSAGE },:test => true)
        else
          raise Error, ERROR_MESSAGE
        end
      end

      def cancel_recurring(profile_id, options = {})
        raise "Profile is nil" if profile_id.blank?
        credit_card_or_reference = options.delete(:credit_card)
        case normalize(credit_card_or_reference)
        when '1'
          Response.new(true, SUCCESS_MESSAGE, {:paid_amount => money}, :test => true)
        when '2'
          Response.new(false, FAILURE_MESSAGE, {:paid_amount => money, :error => FAILURE_MESSAGE },:test => true)
        else
          raise Error, ERROR_MESSAGE
        end
      end

      def status_recurring(profile_id)
        raise "Profile is nil" if profile_id.blank?
        return Response.new(true, SUCCESS_MESSAGE, profiles[profile_id], :test => true) 
      end

      # Suspends a recurring payment profile.
      #
      # ==== Parameters
      #
      # * <tt>profile_id</tt> -- A string containing the +profile_id+ of the
      # recurring payment already in place for a given credit card. (REQUIRED)
      def suspend_recurring(profile_id, options = {})
        raise_error_if_blank('profile_id', profile_id)
        commit 'ManageRecurringPaymentsProfileStatus', build_manage_profile_request(profile_id, 'Suspend', options)
      end

      # Reactivates a suspended recurring payment profile.
      #
      # ==== Parameters
      #
      # * <tt>profile_id</tt> -- A string containing the +profile_id+ of the
      # recurring payment already in place for a given credit card. (REQUIRED)
      def reactivate_recurring(profile_id, options = {})
        raise_error_if_blank('profile_id', profile_id)
        commit 'ManageRecurringPaymentsProfileStatus', build_manage_profile_request(profile_id, 'Reactivate', options)
      end

      # Bills outstanding amount to a recurring payment profile.
      #
      # ==== Parameters
      #
      # * <tt>profile_id</tt> -- A string containing the +profile_id+ of the
      # recurring payment already in place for a given credit card. (REQUIRED)
      def bill_outstanding_amount(profile_id, options = {})
        raise_error_if_blank('profile_id', profile_id)
        commit 'BillOutstandingAmount', build_bill_outstanding_amount(profile_id, options)
      end

      def profile_details_from_options(options)
        options.merge(
          'profile_status'    => 'ActiveProfile',
          'next_billing_date' => ((options[:start_date] || Time.now) + 1.month).to_s
        )
      end
    end
  end
end