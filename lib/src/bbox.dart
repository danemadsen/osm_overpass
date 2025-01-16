/// A type alias for a tuple representing a bounding box (Bbox).
///
/// The bounding box is defined by four `double` values:
/// - The minimum latitude.
/// - The minimum longitude.
/// - The maximum latitude.
/// - The maximum longitude.
typedef Bbox = (double, double, double, double);

/// An extension on the `Bbox` type to provide utility methods.
///
/// The extension provides methods to calculate the union, difference, and intersection
/// of two bounding boxes.
extension BboxExtension on Bbox {
  /// Returns a new `Bbox` that represents the union of this bounding box
  /// and another bounding box.
  ///
  /// The union is defined as the smallest bounding box that contains both
  /// this bounding box and the other bounding box.
  ///
  /// - Parameters:
  ///   - other: The other `Bbox` to union with.
  ///
  /// - Returns: A new `Bbox` that represents the union of the two bounding boxes.
  Bbox union(Bbox other) {
    return (
      this.$1 < other.$1 ? this.$1 : other.$1,
      this.$2 < other.$2 ? this.$2 : other.$2,
      this.$3 > other.$3 ? this.$3 : other.$3,
      this.$4 > other.$4 ? this.$4 : other.$4,
    );
  }

  /// Computes the difference between this bounding box (Bbox) and another bounding box (Bbox).
  ///
  /// The difference is defined as the regions of this bounding box that do not overlap with the other bounding box.
  ///
  /// If there is no overlap between the two bounding boxes, the method returns a list containing only this bounding box.
  ///
  /// If there is an overlap, the method returns a list of bounding boxes representing the non-overlapping regions.
  ///
  /// The regions are divided into top, bottom, left, and right regions relative to the overlapping area.
  ///
  /// - Parameters:
  ///   - other: The other bounding box to compute the difference with.
  ///
  /// - Returns: A list of bounding boxes representing the non-overlapping regions.
  List<Bbox> difference(Bbox other) {
    final List<Bbox> result = [];

    // Check if there's no overlap
    if (this.$1 >= other.$3 ||
        this.$3 <= other.$1 ||
        this.$2 >= other.$4 ||
        this.$4 <= other.$2) {
      // No overlap, return the original bbox
      return [this];
    }

    // Top region
    if (this.$2 < other.$2) {
      result.add((this.$1, this.$2, this.$3, other.$2));
    }

    // Bottom region
    if (this.$4 > other.$4) {
      result.add((this.$1, other.$4, this.$3, this.$4));
    }

    // Left region
    if (this.$1 < other.$1) {
      result.add((
        this.$1,
        other.$2.clamp(this.$2, this.$4),
        other.$1,
        other.$4.clamp(this.$2, this.$4)
      ));
    }

    // Right region
    if (this.$3 > other.$3) {
      result.add((
        other.$3,
        other.$2.clamp(this.$2, this.$4),
        this.$3,
        other.$4.clamp(this.$2, this.$4)
      ));
    }

    return result;
  }

  /// Calculates the intersection of this bounding box with another bounding box.
  ///
  /// If the bounding boxes do not intersect, returns `null`.
  ///
  /// The intersection is determined by comparing the coordinates of the
  /// bounding boxes. If there is an overlap, a new bounding box is created
  /// with the overlapping coordinates.
  ///
  /// - Parameter other: The other bounding box to intersect with.
  /// - Returns: A new `Bbox` representing the intersection of the two bounding
  ///   boxes, or `null` if there is no intersection.
  Bbox? intersection(Bbox other) {
    if (this.$1 >= other.$3 ||
        this.$3 <= other.$1 ||
        this.$2 >= other.$4 ||
        this.$4 <= other.$2) {
      return null;
    }

    return (
      this.$1 > other.$1 ? this.$1 : other.$1,
      this.$2 > other.$2 ? this.$2 : other.$2,
      this.$3 < other.$3 ? this.$3 : other.$3,
      this.$4 < other.$4 ? this.$4 : other.$4,
    );
  }
}
