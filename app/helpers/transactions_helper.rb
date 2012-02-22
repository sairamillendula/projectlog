module TransactionsHelper
  def searching?(params)
    params[:search].present? || params[:category_id].present? || params[:start_date].present? || params[:end_date].present?
  end
  
  def humanize_search_params(params)
    str = []
    str << "that match '#{params[:search]}'" if params[:search].present?
    str << ("in " + (params[:category_id].empty? ? 'All categories' : Category.find(params[:category_id]).name)) if params[:category_id].present?
    str << "from '#{params[:start_date]}'" if params[:start_date].present?
    str << "to '#{params[:end_date]}'" if params[:end_date].present?
    str.join(" ")
  end
end