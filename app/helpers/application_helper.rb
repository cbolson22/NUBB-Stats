module ApplicationHelper
  def sort_link(label, col, sort_col, sort_dir, base_params, url_for_params = ->(p) { players_path(p) })
    active   = col == sort_col
    next_dir = active && sort_dir == "desc" ? "asc" : "desc"
    arrow    = active ? (sort_dir == "desc" ? " ↓" : " ↑") : ""
    link_to "#{label}#{arrow}".html_safe,
            url_for_params.call(base_params.merge(sort: col, dir: next_dir)),
            data: { turbo: false },
            style: active ? "color: #ffe; font-weight: 700;" : "color: rgba(255,255,255,0.8); font-weight: 600;"
  end
end
