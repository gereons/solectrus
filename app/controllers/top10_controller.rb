class Top10Controller < ApplicationController
  include ParamsHandling

  def index
    set_meta_tags title: 'Top 10'
  end

  private

  helper_method def field_items
    Senec::POWER_FIELDS.map do |field|
      {
        name: I18n.t("senec.#{field}"),
        field:,
        href: url_for(**permitted_params.merge(field:, only_path: true)),
      }
    end
  end

  helper_method def period_items
    [
      { name: t('calculator.day'), href: path_with_period('day') },
      { name: t('calculator.month'), href: path_with_period('month') },
      { name: t('calculator.year'), href: path_with_period('year') },
    ]
  end

  def path_with_period(period)
    url_for(permitted_params.merge(period:, only_path: true))
  end
end
