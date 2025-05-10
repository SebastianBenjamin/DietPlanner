<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Your Personalized Meal Planner</title>
    <link rel="icon" type="image/ico" href="healthy-food.png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Carousel Styles */
        .carousel-wrapper {
            position: relative;
            width: 100%;
            overflow: hidden;
            border-radius: 0.75rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .carousel {
            display: flex;
            transition: transform 0.5s ease-in-out;
            height: 384px; /* h-96 */
        }

        .carousel-slide {
            min-width: 100%;
            position: relative;
        }

        .carousel-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .carousel-caption {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
            color: white;
            padding: 2rem;
        }

        /* Feature Card Hover Effect */
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-white text-gray-800">
<div class="container mx-auto px-4">
    <!-- Header -->
    <header class="py-6 border-b border-gray-200">
        <div class="flex justify-between items-center">
            <h1 class="text-3xl font-bold text-primary-900">DietPlanner</h1>
            <div class="flex space-x-4">
                <a href="login" class="px-4 py-2 rounded-lg border border-primary-500 text-primary-500 hover:bg-primary-50 transition">Login</a>
                <a href="signup" class="px-4 py-2 rounded-lg border border-primary-500 text-primary-500 hover:bg-primary-50 transition">Register</a>
            </div>
        </div>
    </header>

    <!-- App Introduction -->
    <section class="mt-8 mb-12 text-center">
        <h2 class="text-4xl font-bold mb-4">Your Personal Nutrition Coach</h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
            DietPlanner helps you achieve your health goals through personalized meal plans,
            tracking, and maintaining proper discipline to keep you healthy.
        </p>
    </section>

    <!-- Key Features -->
    <section class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
        <div class="feature-card bg-white p-6 rounded-xl shadow-md border border-gray-100 transition duration-300">
            <div class="text-primary-500 mb-4 text-3xl">
                <i class="fas fa-utensils"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">Custom Meal Plans</h3>
            <p class="text-gray-600">Create personalized recipes based on your dietary preferences and health goals</p>
        </div>

        <div class="feature-card bg-white p-6 rounded-xl shadow-md border border-gray-100 transition duration-300">
            <div class="text-primary-500 mb-4 text-3xl">
                <i class="fas fa-chart-line"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">Nutrition Tracking</h3>
            <p class="text-gray-600">Monitor meals, water intake, and exercise with our easy-to-use dashboard</p>
        </div>

        <div class="feature-card bg-white p-6 rounded-xl shadow-md border border-gray-100 transition duration-300">
            <div class="text-primary-500 mb-4 text-3xl">
                <i class="fas fa-user-md"></i>
            </div>
            <h3 class="text-xl font-bold mb-2">Expert Guidance</h3>
            <p class="text-gray-600">Get diet recommendations from nutritionists and dietitians</p>
        </div>
    </section>

    <!-- Carousel Section -->
    <section class="mt-12 mb-16 max-w-5xl mx-auto">
        <h2 class="text-2xl font-bold mb-6 text-center">See How It Works</h2>

        <div class="carousel-wrapper">
            <div class="carousel">
                <!-- Slide 1 -->
                <div class="carousel-slide">
                    <img src="https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
                         alt="Healthy breakfast">
                    <div class="carousel-caption">
                        <h3 class="text-2xl font-bold">Personalized Meal Plans</h3>
                        <p class="mt-2">Get recipes tailored to your taste and nutritional needs</p>
                    </div>
                </div>

                <!-- Slide 2 -->
                <div class="carousel-slide">
                    <img src="https://images.unsplash.com/photo-1625937286074-9ca519d5d9df?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                         alt="Nutrition tracking">
                    <div class="carousel-caption">
                        <h3 class="text-2xl font-bold">Comprehensive Tracking</h3>
                        <p class="mt-2">Monitor your daily nutrition and progress</p>
                    </div>
                </div>

                <!-- Slide 3 -->
                <div class="carousel-slide">
                    <img src="https://images.unsplash.com/photo-1561043433-aaf687c4cf04?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                         alt="Fitness goals">
                    <div class="carousel-caption">
                        <h3 class="text-2xl font-bold">Achieve Your Goals</h3>
                        <p class="mt-2">Whether it's weight loss, muscle gain, or healthy living</p>
                    </div>
                </div>
            </div>

            <!-- Carousel Controls -->
            <button id="prevBtn" class="absolute left-4 top-1/2 -translate-y-1/2 bg-black bg-opacity-50 text-white p-3 rounded-full hover:bg-opacity-70 transition">
                <i class="fas fa-chevron-left"></i>
            </button>
            <button id="nextBtn" class="absolute right-4 top-1/2 -translate-y-1/2 bg-black bg-opacity-50 text-white p-3 rounded-full hover:bg-opacity-70 transition">
                <i class="fas fa-chevron-right"></i>
            </button>

            <!-- Indicators -->
            <div class="absolute bottom-4 left-0 right-0 flex justify-center space-x-2">
                <button class="carousel-indicator w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-100 transition" data-index="0"></button>
                <button class="carousel-indicator w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-100 transition" data-index="1"></button>
                <button class="carousel-indicator w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-100 transition" data-index="2"></button>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="my-16">
        <h2 class="text-3xl font-bold mb-12 text-center">How DietPlanner Works</h2>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="text-center p-6">
                <div class="bg-primary-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                    <span class="text-primary-500 text-2xl font-bold">1</span>
                </div>
                <h3 class="text-xl font-bold mb-2">Create Your Profile</h3>
                <p class="text-gray-600">Tell us about your dietary preferences, allergies, and health goals</p>
            </div>

            <div class="text-center p-6">
                <div class="bg-primary-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                    <span class="text-primary-500 text-2xl font-bold">2</span>
                </div>
                <h3 class="text-xl font-bold mb-2">Get Your Plan</h3>
                <p class="text-gray-600">Receive a personalized meal plan tailored just for you</p>
            </div>

            <div class="text-center p-6">
                <div class="bg-primary-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                    <span class="text-primary-500 text-2xl font-bold">3</span>
                </div>
                <h3 class="text-xl font-bold mb-2">Track & Improve</h3>
                <p class="text-gray-600">Monitor your progress and adjust as needed</p>
            </div>
        </div>
    </section>

    <!-- Testimonials -->
    <section class="my-16 bg-primary-50 rounded-xl p-12">
        <h2 class="text-3xl font-bold mb-12 text-center">What Our Users Say</h2>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div class="bg-white p-6 rounded-lg shadow-sm">
                <div class="flex items-center mb-4">
                    <div class="w-12 h-12 rounded-full bg-primary-100 flex items-center justify-center mr-4">
                        <i class="fas fa-user text-primary-500"></i>
                    </div>
                    <div>
                        <h4 class="font-bold">Sarah J.</h4>
                        <p class="text-gray-500 text-sm">Lost 15kg in 3 months</p>
                    </div>
                </div>
                <p class="text-gray-700">"DietPlanner completely changed my relationship with food. The personalized recipes are delicious and easy to make!"</p>
            </div>

            <div class="bg-white p-6 rounded-lg shadow-sm">
                <div class="flex items-center mb-4">
                    <div class="w-12 h-12 rounded-full bg-primary-100 flex items-center justify-center mr-4">
                        <i class="fas fa-user text-primary-500"></i>
                    </div>
                    <div>
                        <h4 class="font-bold">Michael T.</h4>
                        <p class="text-gray-500 text-sm">Fitness Enthusiast</p>
                    </div>
                </div>
                <p class="text-gray-700">"Finally a meal planner that understands my macros needs for weight training. The grocery lists save me hours!"</p>
            </div>
        </div>
    </section>

    <!-- Final CTA -->
    <section class="my-20 text-center">
        <h2 class="text-3xl font-bold mb-6">Ready to Transform Your Health?</h2>
        <p class="max-w-2xl mx-auto mb-8 text-gray-600">Join thousands of users who have achieved their health goals with DietPlanner</p>
        <a href="dashboard" class="inline-block bg-primary-500 text-black px-8 py-4 rounded-lg font-bold hover:bg-primary-600 transition duration-300 transform hover:scale-105 shadow-lg">
            Start Your Journey Today
        </a>
    </section>

    <!-- Footer -->
    <footer class="mt-20 py-8 border-t border-gray-200">
        <div class="flex flex-col md:flex-row justify-between items-center">
            <div class="mb-4 md:mb-0">
                <h3 class="text-xl font-bold">DietPlanner</h3>
                <p class="text-gray-600">Your personal nutrition assistant</p>
            </div>
            <div class="flex space-x-6">
                <a href="https://github.com/SebastianBenjamin/DietPlanner" class="text-gray-600 hover:text-primary-500"><i class="fab fa-github"></i></a>
            </div>
        </div>
        <div class="mt-8 text-center text-gray-500 text-sm">
            <p>&copy; 2025 DietPlanner. All rights reserved.</p>
        </div>
    </footer>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const carousel = document.querySelector('.carousel');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        const indicators = document.querySelectorAll('.carousel-indicator');
        const slides = document.querySelectorAll('.carousel-slide');
        let currentIndex = 0;
        let carouselInterval;

        function updateCarousel() {
            carousel.style.transform = `translateX(-${currentIndex * 100}%)`;

            // Update indicators
            indicators.forEach((indicator, index) => {
                if (index === currentIndex) {
                    indicator.classList.remove('bg-opacity-50');
                    indicator.classList.add('bg-opacity-100');
                } else {
                    indicator.classList.remove('bg-opacity-100');
                    indicator.classList.add('bg-opacity-50');
                }
            });
        }

        function startAutoCarousel() {
            carouselInterval = setInterval(() => {
                currentIndex = (currentIndex + 1) % slides.length;
                updateCarousel();
            }, 5000);
        }

        function stopAutoCarousel() {
            clearInterval(carouselInterval);
        }

        // Event listeners
        nextBtn.addEventListener('click', () => {
            currentIndex = (currentIndex + 1) % slides.length;
            updateCarousel();
            stopAutoCarousel();
            startAutoCarousel();
        });

        prevBtn.addEventListener('click', () => {
            currentIndex = (currentIndex - 1 + slides.length) % slides.length;
            updateCarousel();
            stopAutoCarousel();
            startAutoCarousel();
        });

        indicators.forEach(indicator => {
            indicator.addEventListener('click', () => {
                currentIndex = parseInt(indicator.getAttribute('data-index'));
                updateCarousel();
                stopAutoCarousel();
                startAutoCarousel();
            });
        });

        // Pause on hover
        carousel.parentElement.addEventListener('mouseenter', stopAutoCarousel);
        carousel.parentElement.addEventListener('mouseleave', startAutoCarousel);

        // Initialize
        updateCarousel();
        startAutoCarousel();
    });
</script>
</body>
</html>