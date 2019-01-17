require 'rails_helper'

RSpec.describe "departments#create", type: :request do
  subject(:make_request) do
    jsonapi_post "/api/v1/departments", payload
  end

  describe 'basic create' do
    let(:payload) do
      {
        data: {
          type: 'departments',
          attributes: attributes_for(:department)
        }
      }
    end

    it 'works' do
      expect(DepartmentResource).to receive(:build).and_call_original
      expect {
        make_request
      }.to change { Department.count }.by(1)
      department = Department.last
      expect(response.status).to eq(201)
    end
  end

  describe 'create with notes' do
    let(:payload) do
      {
        data: {
          type: 'departments',
          attributes: attributes_for(:department),
          relationships: {
              "notes":{
                  data:[
                      {
                          type: 'notes',
                          :'temp-id' => "nn",
                          method: 'create'
                      }
                  ]
              }
          },
        },
        included: [
            {
                type: 'notes',
                :'temp-id' => "nn",
                attributes: {
                  # notable_type: 'Department'
                }
            }
        ]
      }
    end

    it 'works' do
      expect(DepartmentResource).to receive(:build).and_call_original
      expect {
        make_request
      }.to change { Department.count }.by(1)
      department = Department.last
      expect(department.notes.count).to eq(1)
      expect(response.status).to eq(201)
    end
  end
end
