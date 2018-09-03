require 'rails_helper'

RSpec.describe EmployeeResource, type: :resource do
  describe 'serialization' do
    let!(:employee) { create(:employee, attrs) }

    let(:attrs) do
      {
        first_name: 'jane',
        last_name: 'doe',
        age: 40
      }
    end

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(employee.id)
      expect(data.jsonapi_type).to eq('employees')
      expect(data.first_name).to eq('jane')
      expect(data.last_name).to eq('doe')
      expect(data.age).to eq(40)
      expect(data.created_at).to eq(datetime(employee.created_at))
      expect(data.updated_at).to eq(datetime(employee.updated_at))
    end
  end

  describe 'filtering' do
    let!(:employee1) { create(:employee) }
    let!(:employee2) { create(:employee) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: employee2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([employee2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:employee1) { create(:employee) }
      let!(:employee2) { create(:employee) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            employee1.id,
            employee2.id
          ])
        end
      end

      context 'when descending' do
        before do
          params[:sort] = '-id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            employee2.id,
            employee1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end