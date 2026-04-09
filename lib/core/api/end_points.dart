class EndPoints {
  static String baseUrl = "https://supermarket-dan1.onrender.com/api/v1/";
  static String signIn = "auth/signIn";
  static String signUp = "auth/signUp";
  static String resetPassword = "auth/sendPassEmail";
  static String verificationResetPass = "auth/activeResetPass";
  static String confirmResetPassword = "auth/resetPassword";
  static String getUesrData = "portfoilo/userData";
  static String getAllProductsData = "home/products";
  static String getPopularProductsData = "home/productsFilter";
  static String getCategoriesData = "home/categories";
  static String getBrandsData = "home/brands";
  static String getProductsByCategory(String categoryName){
    return  "home/products/category/$categoryName";
  }
  static String getProductsByBrand(String brandName){
    return  "home/products/brand/$brandName";
  }
}

class ApiKey {
  static String status = "status";
  static String user = "user";
  static String errorMessage = "message";
  static String name = "name";
  static String phone = "phone";
  static String email = "email";
  static String password = "password";
  static String confirmPassword = "confirmPassword";
  static String token = "token";
  static String message = "massage";
  static String id = "id";
  static String code = "code";
  static String role = "role";
  static String image = "image";
  static String address = "address";
}
