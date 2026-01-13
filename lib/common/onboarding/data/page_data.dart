class PageData {
  final String svgPath;
  final String title;
  final String description;

  const PageData(this.svgPath, this.title, this.description);
}

const svgBasePath = 'assets/svg';
final orientationPages = [
  PageData(
    '$svgBasePath/Search engines-bro 1.svg',
    'Quickly Find Medications',
    'Search for prescriptions or over-the-counter meds by name, brand, or condition.',
  ),
  PageData(
    '$svgBasePath/Receipt-bro.svg',
    'Compare Prices',
    'Compare real-time pricing and availability across pharmacies',
  ),
  PageData(
    '$svgBasePath/Location search-pana.svg',
    'Locate Pharmacies',
    'See nearby pharmacies with your medication in stock, check operating hours, and get directions instantly.',
  ),
  PageData(
    '$svgBasePath/Secure data-pana.svg',
    'Safely Store Medical History',
    'Keep your health records secure—track conditions, allergies, prescriptions, and treatments in one encrypted place',
  ),
  PageData(
    '$svgBasePath/Pharmacist-bro 1.svg',
    'Improve Discoverability & Trust',
    'Join your local health network — get found by patients, manage inventory, and keep simple, reliable sales records.',
  ),
];
