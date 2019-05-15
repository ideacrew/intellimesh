# frozen_string_literal: true

require "spec_helper"
require 'intellimesh'

class MessageIncluded
  include Intellimesh::Messages::Message

  # This declaration keeps developer honest about initilizing code in the module
  def initialize
  end

  def load_header_property_set
    message(local_header_properties)
  end

  def load_meta_property_set
    message(local_meta_properties)
  end

  def load_context_property_set
    message(local_context_properties)
  end

  def load_all_property_sets
  	header_hash = hash_merge([
  															local_header_properties, 
  															{ meta: local_meta_properties}, 
  															{ context: local_context_properties}
  														])
# binding.pry
  	message(header_hash)
  end

  def local_header_properties
    {
      to:             'amqp://exchange_name',
      type:           :object,
    }
  end

  def local_context_properties
    {
      priority:       :now,
      expires:        300,
      reply_to:       'amqp://exchange_name/reply_to_queue',
    }
  end

  def local_meta_properties
    {
      locale:         'en',
      encrypted:			false,
      ack_requested:  true,
    }
  end

  class EventJob
    include Intellimesh::Messages::Message

  end

  class TrackedEventJob
    include Intellimesh::Messages::Message

  end

  class CommandJob
    include Intellimesh::Messages::Message

  end

  class CommandServiceJob
    include Intellimesh::Messages::Message


    def received_message
    end

  end


  RSpec.describe Intellimesh::Messages::Message do

    let(:header_defaults) do  {
        from: nil,
        to: nil,
        subject: nil,
        submitted_at: nil,
        type: :object,
        errors: {},
        context: context_defaults,
        meta: {},
      }
    end

    let(:context_defaults) do  {
        enqueued_at: nil,
        priority: :now,
        expires: 0,
        reply_to: nil,
        routing_slip: {},
      }
    end

    context "A class instance with an initialized Message" do
      # subject { MessageIncluded.new().message(message_options) }
      subject { MessageIncluded.new() }
      before 	{ subject.message(message_options) }

      let(:id_key)            { :id }
      let(:message_options)		{ {type: :object} }

      it "the Message Header should initialize with default values" do
        expect(subject.message_header.except(:id)).to include(header_defaults)
        expect(subject.message_context).to include(context_defaults)
        expect(subject.message_meta).to eq({})
      end

      it "and the Message Header should include an :id key" do
        expect(subject.message_header).to have_key(id_key)
        expect(subject.message_header[:id]).to_not be_nil
      end

      it "and the Message Meta keys should be nil" do
        expect(subject.message_header[:meta]).to eq({})
      end

      it "and the Message Body should be empty" do
        expect(subject.message_body).to eq({})
      end

      context "and Message Header properties are individually updated" do

        context "an update to the readlonly :id property is attempted" do
          let(:id)   { "123abc" }

          it("should raise an Argument error") do
            expect{subject.update_message_header(:id => id)}.to raise_error(ArgumentError)
          end
        end

        context "an update to the :submitted_at property is attempted with valid value" do
          let(:timestamp)   { Time.now.utc }

          before { subject.update_message_header(submitted_at: timestamp) }

          it "should update the submitted_at property" do
            expect(subject.message_header[:submitted_at]).to eq timestamp
          end
        end
      end

      context "and Message Header properties are updated as a set" do
        before { subject.load_header_property_set }

        it "should update the header properties hash" do
          expect(subject.message_header).to include(subject.local_header_properties)
        end
      end

      context "and a Message Meta property is individually added" do
        let(:new_meta_property_name)	{ "favorite_color" }
        let(:new_meta_value)					{ "green" }
        let(:new_meta_property)				{ { new_meta_property_name.to_sym => new_meta_value } }

        before { subject.update_message_header(new_meta_property) }

        it "should add the new property" do
          expect(subject.message_header[:meta].keys).to include new_meta_property_name.to_sym
          expect(subject.message_meta[new_meta_property_name.to_sym]).to eq new_meta_value
          expect(subject.message_header[:meta][new_meta_property_name.to_sym]).to eq new_meta_value
        end
      end

      context "and Message Meta propertes are loaded as a set" do
        before { subject.load_meta_property_set }

        it "should initialize the meta properties hash" do
          expect(subject.message_meta).to eq subject.local_meta_properties
        end

        it "should update the meta hash in the parent Header properties" do
          expect(subject.message_header[:meta]).to eq subject.local_meta_properties
        end

        context "and a Message Meta property is individually updated" do
          let(:updated_meta_property)		{ { encrypted: true } }
          before { subject.update_message_header(updated_meta_property) }

          it "should update the existing value" do
            expect(subject.message_header[:meta][updated_meta_property.keys.first]).to eq updated_meta_property.values.first
          end
        end
      end

      context "and a Message Context property is individually updated" do
        context "an update to the :priority property is attempted with a valid value" do
          let(:hourly_priority)   { :hourly }

          before { subject.update_message_header({priority: hourly_priority }) }

          it("should update the :priority property") do
            expect(subject.message_context[:priority]).to eq hourly_priority
          end
        end
      end

      context "and Message Context propertes are loaded as a set" do
        before { subject.load_context_property_set }

        it "should initialize the context properties hash" do
          expect(subject.message_context).to include subject.local_context_properties
        end

        it "should update the context hash in the parent Header properties" do
          expect(subject.message_header[:context]).to include subject.local_context_properties
        end

        context "and a Message context property is individually updated" do
          let(:updated_context_property)		{ { expires: 42 } }
          before { subject.update_message_header(updated_context_property) }

          it "should update the existing value" do
            expect(subject.message_header[:context][updated_context_property.keys.first]).to eq updated_context_property.values.first
          end
        end
      end

      context "and Message is created all at once from nested hashes" do
        before { subject.load_all_property_sets }

        it "should update the meta hash in the parent Header properties" do
          expect(subject.message_header[:meta]).to eq subject.local_meta_properties
        end

        it "should initialize the meta properties hash" do
          expect(subject.message_meta).to include subject.local_meta_properties
        end

        it "should initialize the context properties hash" do
          expect(subject.message_context).to include subject.local_context_properties
        end

      end

      context "and a Message body is added" do
      end
    end
  end
end
