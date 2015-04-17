class MarkingSchemesController < ApplicationController
  include MarkingSchemesHelper
  
  def index
    # @assignments = Assignment.all
    # @grade_entry_forms = GradeEntryForm.all

    @marking_scheme    = MarkingScheme.new
    @assignments       = Assignment.all
    @grade_entry_forms = GradeEntryForm.all

    @all_gradable_items = @assignments + @grade_entry_forms
    @all_gradable_items.count.times do
      @marking_scheme.marking_weights.build
    end
  end
  
  def populate
    render json: get_table_json_data
  end

  def create
    ActiveRecord::Base.transaction do
      begin
        # save marking scheme
        marking_scheme = MarkingScheme.new(name: params["marking_scheme"]["name"])
        marking_scheme.save!

        # save marking weights
        params["marking_scheme"]["marking_weights_attributes"].each do |key, obj|
          is_assignment = (obj["type"] == "Assignment")
          marking_weight = MarkingWeight.new(gradable_item_id: obj["id"], is_assignment: is_assignment, marking_scheme_id: marking_scheme.id, weight: obj["weight"])
          marking_weight.save!
        end
      rescue ActiveRecord::RecordInvalid => invalid
        # Failed
        puts "********FAILED*******"
      end
    end

    redirect_to marking_schemes_path()
  end
  
  def new
    @marking_scheme    = MarkingScheme.new
    @assignments       = Assignment.all
    @grade_entry_forms = GradeEntryForm.all

    @all_gradable_items = @assignments + @grade_entry_forms
    @all_gradable_items.count.times do
      @marking_scheme.marking_weights.build
    end
  end

  def edit
  end
end