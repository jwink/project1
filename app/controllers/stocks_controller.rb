
class StocksController < ApplicationController
  def new
    @portfolio = Portfolio.find(params.fetch(:portfolio_id))
    @stock = Stock.new
  end

  def create
    stock_name = stock_params["name"]
    @portfolio_id = params[:portfolio_id]
    @list = Stock.find_list(stock_name)
  end

  def show
    stock = Stock.create(ticker: params.fetch(:id), name: params.fetch(:name))
    stock.update_stock(stock.ticker)
    portfolio = Portfolio.find(params.fetch(:portfolio_id))
    portfolio.shares.create(num_shares: params.fetch(:num_shares), stock_id: stock.id)
    redirect_to "/portfolios/#{portfolio.id}"
  end

  def display
    price_hash = Day.get_prices(params[:sym])
    @sorted_price_array = Hash[price_hash.sort].values
    @url = Gchart.line(:data => @sorted_price_array)
  end

  def edit
    @p = params
  end

  def update
    redirect_to "/portfolios/#{params.fetch(:portfolio_id)}"
  end

  def destroy
    stock_id = params[:id]
    portfolio_id = params[:portfolio_id]
    share = Share.where(portfolio_id: portfolio_id, stock_id: stock_id).take
    Share.delete(share.id)
    redirect_to "/portfolios/#{portfolio_id}"
  end


  private

  def stock_params
    params.require(:stock).permit(:name)
  end

end
