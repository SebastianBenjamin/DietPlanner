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
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            100: '#f0f0f0',
                            500: '#333333',
                            900: '#000000',
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-white text-black">
<div class="container mx-auto px-4">
    <!-- Header -->
    <header class="py-8 border-b border-gray-200">
        <h1 class="text-3xl font-bold text-center">DietPlanner</h1>
    </header>

    <!-- Main Content -->
    <main>
        <!-- Carousel Section -->
        <section class="mt-12 max-w-4xl mx-auto relative overflow-hidden shadow-lg">
            <div id="carousel" class="flex transition-transform duration-300">
                <!-- Slide 1 -->
                <div class="w-full flex-shrink-0 relative">
                    <img src="https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
                         alt="Healthy breakfast"
                         class="w-full h-96 object-cover">
                    <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white p-6">
                        <h2 class="text-2xl font-bold">Personalized Meal Plans</h2>
                        <p class="mt-2">Tailored to your dietary needs and preferences</p>
                    </div>
                </div>

                <!-- Slide 2 -->
                <div class="w-full flex-shrink-0 relative">
                    <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
                         alt="Healthy food"
                         class="w-full h-96 object-cover">
                    <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white p-6">
                        <h2 class="text-2xl font-bold">Nutrition Tracking</h2>
                        <p class="mt-2">Monitor your macros and micros effortlessly</p>
                    </div>
                </div>

                <!-- Slide 3 -->
                <div class="w-full flex-shrink-0 relative">
                    <img src="https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
                         alt="Fitness tracking"
                         class="w-full h-96 object-cover">
                    <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white p-6">
                        <h2 class="text-2xl font-bold">Achieve Your Goals</h2>
                        <p class="mt-2">Whether it's weight loss, muscle gain, or maintenance</p>
                    </div>
                </div>
            </div>

            <!-- Carousel Controls -->
            <button id="prevBtn" class="absolute left-4 top-1/2 -translate-y-1/2 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-70 transition">
                <i class="fas fa-chevron-left"></i>
            </button>
            <button id="nextBtn" class="absolute right-4 top-1/2 -translate-y-1/2 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-70 transition">
                <i class="fas fa-chevron-right"></i>
            </button>

            <!-- Indicators -->
            <div class="absolute bottom-4 left-0 right-0 flex justify-center space-x-2">
                <button class="carousel-indicator w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-100 transition" data-index="0"></button>
                <button class="carousel-indicator w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-100 transition" data-index="1"></button>
                <button class="carousel-indicator w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-100 transition" data-index="2"></button>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="mt-16 text-center">
            <h2 class="text-3xl font-bold mb-6">Ready to Transform Your Eating Habits?</h2>
            <p class="max-w-2xl mx-auto mb-8 text-gray-700">Get personalized meal plans designed by nutrition experts to help you reach your health goals.</p>
            <a href="dashboard" class="inline-block bg-black text-white px-8 py-4 rounded-lg font-bold hover:bg-gray-800 transition duration-300 transform hover:scale-105">
                Plan Your Diet Now
            </a>
        </section>
    </main>

    <!-- Footer -->
    <footer class="mt-20 py-8 border-t border-gray-200 text-center text-gray-600">
        <p>&copy; 2025 DietPlanner. All rights reserved.</p>
    </footer>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const carousel = document.getElementById('carousel');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        const indicators = document.querySelectorAll('.carousel-indicator');

        let currentIndex = 0;
        const totalSlides = document.querySelectorAll('#carousel > div').length;

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

        // Next button click
        nextBtn.addEventListener('click', () => {
            currentIndex = (currentIndex + 1) % totalSlides;
            updateCarousel();
        });

        // Previous button click
        prevBtn.addEventListener('click', () => {
            currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
            updateCarousel();
        });

        // Indicator clicks
        indicators.forEach(indicator => {
            indicator.addEventListener('click', () => {
                currentIndex = parseInt(indicator.getAttribute('data-index'));
                updateCarousel();
            });
        });

        // Auto-advance carousel
        setInterval(() => {
            currentIndex = (currentIndex + 1) % totalSlides;
            updateCarousel();
        }, 2000);
    });
</script>
</body>
</html>