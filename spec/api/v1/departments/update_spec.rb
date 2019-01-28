require 'rails_helper'

RSpec.describe "departments#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/departments/#{department.id}", payload
  end

  describe 'basic update' do
    let!(:department) { create(:department) }

    let(:payload) do
      {
        data: {
          id: department.id.to_s,
          type: 'departments',
          attributes: {
            name: 'changed!'
          }
        }
      }
    end

    it 'updates the resource' do
      expect(DepartmentResource).to receive(:find).and_call_original
      expect {
        make_request
      }.to change { department.reload.attributes }
      expect(response.status).to eq(200)
    end
  end

  describe 'update with removing notes' do
    let!(:department) { create(:department) }
    let!(:notes) {create_list(:department_note, 5, notable: department)}

    let(:payload) do
      {
        data: {
          id: department.id.to_s,
          type: 'departments',
          attributes: {
            name: 'changed!'
          },
          relationships: {
              "notes":{
                  data:[
                      {
                          type: 'notes',
                          id: notes.first.id.to_s,
                          method: 'destroy'
                      }
                  ]
              }
          },
        }
      }
    end

    it 'removes note' do
      expect(DepartmentResource).to receive(:find).and_call_original
      expect(department.notes.count).to eq(5)
      expect{make_request}.to change {department.notes.count}.by(-1)
      expect(response.status).to eq(200)
    end
  end
end
