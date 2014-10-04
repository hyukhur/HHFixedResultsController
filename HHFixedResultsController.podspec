Pod::Spec.new do |s|
  s.name         = "HHFixedResultsController"
  s.version      = "0.0.3"
  s.summary      = "collection based result controller as NSFetchedResultsController"

  s.description  = <<-DESC
                   We usualy use NSFetchedResultsController with UITableView.
                   but it need NSManagedObject and Core Data.
                   so just drop-in result controller with KVC objects be used with UITableView.
                   DESC

  s.homepage     = "https://github.com/hyukhur/HHFixedResultsController"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Hyuk Hur" => "hyukhur@gmail.com" }
  s.social_media_url   = "http://twitter.com/hyukhur"
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/hyukhur/HHFixedResultsController.git", :tag => s.version.to_s }
  s.source_files  = "HHFixedResultsController/Classes", "Classes/**/*.{h,m}"
  s.public_header_files = "HHFixedResultsController/Classes/**/*.h"
  s.requires_arc = true
end
