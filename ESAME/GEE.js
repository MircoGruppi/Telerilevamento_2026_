function maskS2clouds(image) {
  var qa = image.select('QA60');
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
                 .and(qa.bitwiseAnd(cirrusBitMask).eq(0));
  return image.updateMask(mask).divide(10000);
}

var bands_to_export = ['B2', 'B3', 'B4', 'B8'];


var col_2019 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(geometry)
  .filterDate('2019-05-01', '2019-08-31')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
  .map(maskS2clouds);

var composite_2019 = col_2019.median().clip(geometry).select(bands_to_export);

Export.image.toDrive({
  image: composite_2019,
  description: 'Australia_2019_bands',
  folder: 'GEE_exports',
  fileNamePrefix: 'Australia_2019_bands',
  region: geometry,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

var col_2020 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(geometry)
  .filterDate('2020-05-01', '2020-08-31')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
  .map(maskS2clouds);

var composite_2020 = col_2020.median().clip(geometry).select(bands_to_export);

Export.image.toDrive({
  image: composite_2020,
  description: 'Australia_2020_bands',
  folder: 'GEE_exports',
  fileNamePrefix: 'Australia_2020_bands',
  region: geometry,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});

var col_2026 = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
  .filterBounds(geometry)
  .filterDate('2026-05-01', '2026-08-31')
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 20))
  .map(maskS2clouds);

var composite_2026 = col_2026.median().clip(geometry).select(bands_to_export);

Export.image.toDrive({
  image: composite_2026,
  description: 'Australia_2026_bands',
  folder: 'GEE_exports',
  fileNamePrefix: 'Australia_2026_bands',
  region: geometry,
  scale: 10,
  crs: 'EPSG:4326',
  maxPixels: 1e13
});
