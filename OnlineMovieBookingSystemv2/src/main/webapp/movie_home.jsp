<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Package" %>
<%@ page import="com.model.Movie" %>
<%@ page import="com.model.Feedback" %>
<%@ page import="java.util.List" %>
<% 
    List<Package> packages = (List<Package>) request.getAttribute("packages");
    List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
    List<Movie> movies = (List<Movie>) request.getAttribute("movies");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie Land</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #121212;
            color: #fff;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .navbar {
            width: 100%;
            background-color: #222;
            padding: 10px 60px;
            display: flex;
            align-items: center;
            justify-content: space-around;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .navbar-title {
            font-size: 24px;
            font-weight: bold;
            color: #fff;
            text-decoration: none;
        }

        .avatar {
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
        }

        .section-title {
            font-size: 24px;
            margin: 20px 0;
        }

        .content-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            width: 90%;
            margin-bottom: 40px;
        }

        .card {
            background-color: #333;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.6);
            transition: transform 0.2s;
            display: flex;
            flex-direction: column;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .card-details {
            padding: 10px;
            display: flex;
            flex-direction: column;
            align-items: start;
            justify-content: space-between;
            flex: 1;
        }

        .card-title {
            font-size: 18px;
            font-weight: bold;
        }

        .card-text {
            font-size: 14px;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.8);
            padding-top: 60px;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: #333;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 90%;
            max-width: 600px;
            border-radius: 10px;
        }

        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: #fff;
            text-decoration: none;
        }

        form {
            display: flex;
            flex-direction: column;
            width: 100%;
        }

        input, textarea, select, button {
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            border: none;
        }

        button {
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="#" class="navbar-title">Movie Land</a>
        <img src="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png" alt="User Avatar" class="avatar" onclick="location.href='user?action=edit';">
    </div>

    <h1 class="section-title">Movies</h1>
    <div class="content-container">
        <%-- Display Movies --%>
        <% 
            if(movies != null) {
                for(Movie movie : movies) {
        %>
                    <div class="card" onclick="openFeedbackModal('<%= movie.getName() %>')">
                        <img src="<%= movie.getImageUrl() %>" alt="Movie" class="movie-image">
                        <div class="card-details">
                            <div class="card-title"><%= movie.getName() %></div>
                            <div class="card-text"><%= movie.getDescription() %></div>
                            <div class="card-text"><%= movie.getReleasedYear() %></div>
                        </div>
                    </div>
        <% 
                }
            }
        %>
    </div>



    <h1 class="section-title">Packages</h1>
    <div class="content-container">
        <%-- Display Movies --%>
        <% 
            if(packages != null) {
                for(Package pkg : packages) {
        %>
                       
                       <div class="card">
                        <div class="card-details">
                            <div class="card-title"><%= pkg.getPackageName() %></div>
                            <div class="card-text"><%= pkg.getDescription() %></div>
                            <div class="card-text">LKR <%= pkg.getPrice() %></div>
                        </div>
                       </div>
                    
        <% 
                }
            }
        %>
    </div>

    <!-- Feedback Modal -->
    <div id="feedbackModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeFeedbackModal()">&times;</span>
            <h2>Add Feedback for <span id="movieTitle"></span></h2>
            <form action="feedback?action=add" method="post">
                <input type="hidden" name="movieId" id="movieId" value="">
                
                <label for="userName">User Name:</label>
                <input type="text" name="userName" required>

                <label for="comment">Comment:</label>
                <textarea name="comment" rows="4" required></textarea>

                <label for="rate">Rate:</label>
                <input type="number" name="rate" min="1" max="5" required>

                <button type="submit">Submit Feedback</button>
            </form>
        </div>
    </div>

    <script>
        function openFeedbackModal(movieTitle) {
            var movieId = getMovieId(movieTitle);
            document.getElementById('movieTitle').innerHTML = movieTitle;
            document.getElementById('movieId').value = movieId;
            document.getElementById('feedbackModal').style.display = 'block';
        }

        function closeFeedbackModal() {
            document.getElementById('feedbackModal').style.display = 'none';
        }

        function getMovieId(movieTitle) {
            // Implement logic to get the movieId based on the movieTitle
            // This can be done using JavaScript or by fetching data from the server
            // For simplicity, I'm returning a hardcoded value here.
            return 1; // Replace with actual movieId
        }
    </script>
</body>
</html>
