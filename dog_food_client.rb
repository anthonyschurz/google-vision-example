require 'google/apis/vision_v1'

class DogFoodClient
  API_KEY = 'your google cloud platform api key'
  EXAMPLES = ['chihuahua-muffin', 'labradoodle-friedchicken', 'puppy-bagel', ]
  DOG_LABELS = ['pet', 'dog breed', 'dog breed group']
  FOOD_LABELS = ['food']
  Vision = Google::Apis::VisionV1

  # Iterate over all examples, counting 'correct' labels
  def evaluate_all
    EXAMPLES.each_with_object({}) do |example, hsh|
      puts "Example: #{example}"

      dog_annotations  = annotate(example, 'dog')
      food_annotations = annotate(example, 'food')
      dogs_with_dog_labels  = count_occurrences(dog_annotations, DOG_LABELS)
      dogs_with_food_labels = count_occurrences(dog_annotations, FOOD_LABELS)
      food_with_dog_labels  = count_occurrences(food_annotations, DOG_LABELS)
      food_with_food_labels = count_occurrences(food_annotations, FOOD_LABELS)

      puts "\tDogs: #{dogs_with_dog_labels} with dog labels"
      puts "\tDogs: #{dogs_with_food_labels} with food labels"
      puts "\tFood: #{food_with_dog_labels} with dog labels"
      puts "\tFood: #{food_with_food_labels} with food labels"
    end
  end

  # Return descriptions for all images in a directory
  # @param example [String] subdirectory of /img
  # @param type [String] subdirectory of /img/example
  #
  # @return [Array[Array[String]]] Nested array of labels for each image
  def annotate(example, type)
    img_paths  = `ls img/#{example}/#{type}/*.png`.split("\n")

    request = make_request(img_paths)
    responses = service.annotate_image(request)
    responses.responses.map { |resp| resp.label_annotations.map(&:description) }
  end

  # Set up a batch request to the Google Cloud Vision API
  # @param img_paths [Array[String]] List of paths to image files
  #
  # @return [Google::Apis::VisionV1::BatchAnnotateImagesRequest]
  def make_request(img_paths)
    # Load contents of the imagefiles and instantiate Google::Apis::VisionV1::Image objects
    img_data = img_paths.map { |p| File.open(p).read }
    images   = img_data.map { |d| Vision::Image.new(content: d)}

    # Maximum of 5 labels per image
    features = [ Vision::Feature.new(max_results: 5, type: 'LABEL_DETECTION') ]

    # Instantiate individual annotation API requests for each image
    requests = images.map { |i| Vision::AnnotateImageRequest.new(image: i, features: features) }

    # Combine requests into a single batch - max of 50
    batch_request = Vision::BatchAnnotateImagesRequest.new(requests: requests)
  end


  # Count how many of the predicted and actual labels co-occur
  # @param predicted [Array[String]] array of annotations returned from API
  # @param actual [Array[String]] array of truthful labels
  #
  # @return [Integer] count of co-occurences
  def count_occurrences(predicted, actual)
    correct = predicted.select do |p|
      !(p & actual).empty?
    end
    correct.count
  end

  # Memoized VisionService
  # @return [Google::Apis::VisionV1::VisionService]
  def service
    return @service unless @service.nil?
    @service = Vision::VisionService.new
    @service.key = API_KEY
    @service
  end
end

DogFoodClient.new.evaluate_all