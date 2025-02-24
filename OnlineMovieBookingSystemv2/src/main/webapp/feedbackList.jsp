<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Feedback" %>
<%@ page import="com.model.Movie" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dao.FeedbackDAO" %>
<%@ page import="com.dao.MovieDAO" %>
<%@ page import="java.util.Iterator" %>
<%
    // Fetch movies from the database
    MovieDAO movieDAO = new MovieDAO();
    List<Movie> movies = movieDAO.getAllMovies();

    // Fetch feedback list from the database
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Feedback> feedbackList = feedbackDAO.getAllFeedback();
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #121212; /* Dark background */
            color: #ccc; /* Light grey text color */
            font-family: 'Arial', sans-serif;
            margin-top: 20px;
        }
        .modal-content {
            background-color: #1a1a1a; /* Darker shade for modal */
            border-radius: 10px;
        }
        .feedback-card {
            background-color: #282828; /* Slightly lighter black for cards */
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            padding: 15px;
        }
        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .feedback-header h5 {
            margin-bottom: 0;
            color: #fff; /* White text color for header */
        }
        .star-rating {
            color: #db3a34; /* Dark red for stars */
            cursor: pointer;
        }
        .star-rating .fa {
            font-size: 20px;
        }
        .btn-outline-primary {
            border-color: #db3a34; /* Dark red border for buttons */
            color: #db3a34; /* Dark red text for buttons */
        }
        .btn-outline-primary:hover {
            background-color: #db3a34; /* Dark red background on hover */
            color: #ffffff;
        }
        .btn-danger {
            background-color: #b12d2d; /* Darker red for danger button */
            border-color: #b12d2d;
        }
        .btn-danger:hover {
            background-color: #992424;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            line-height: 1.5;
            border-radius: 0.2rem;
        }
        .modal-backdrop.show {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div style="display:flex;width:80vw;justify-content:space-between;"><h2 class="mb-3" style="color: #fff;">Feedback List</h2> 
        <a href="movie" style="background-color: #db3a34; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; transition: background-color 0.3s; display: inline-block;">Home</a>

        </div>
        <%-- Feedback List --%>
        <%
            if(feedbackList != null) { 
                for (Feedback feedback : feedbackList) {
        %>
            <div class="card feedback-card">
                <div class="card-body">
                    <div class="feedback-header">
                        <h5 class="card-title">Feedback: <%= feedback.getComment() %></h5>
                        <div>
                            <button 
                            class="btn btn-outline-primary btn-sm" 
                            onclick=
                            "openEditModal(<%= feedback.getFeedbackId() %>, '<%= feedback.getComment() %>', <%= feedback.getRate() %>, '<%= feedback.getMovieId() %>')">Edit</button>
                            <button class="btn btn-danger btn-sm" onclick="location.href='feedback?action=delete&feedbackId=<%= feedback.getFeedbackId() %>'">Delete</button>
                        </div>
                    </div>
                    <p class="card-text"><small>Comment: <%= feedback.getComment() %></small></p>
                    <div class="star-rating">
                        <% for (int i = 1; i <= 5; i++) {
                            if (i <= feedback.getRate()) {
                        %>
                            <span class="fa fa-star checked"></span>
                        <% } else { %>
                            <span class="fa fa-star"></span>
                        <% }
                        } %>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>

    <!-- Edit Feedback Modal -->
    <div class="modal fade" id="editFeedbackModal" tabindex="-1" aria-labelledby="editFeedbackModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editFeedbackModalLabel">Edit Feedback</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editFeedbackForm" action="feedback?action=update" method="post">
                        <input type="hidden" id="editFeedbackId" name="feedbackId">
                              <input type="hidden" id="editMovieId" name="movieId">
                                 <input type="hidden" id="editUsername" name=userName>
                        <div class="mb-3">
                            <label for="editComment" class="form-label">Comment:</label>
                            <textarea id="editComment" name="comment" rows="4" class="form-control" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="editRate" class="form-label">Rate:</label>
                            <select class="form-select" id="editRate" name="rate">
                                <option value="1">1 Star</option>
                                <option value="2">2 Stars</option>
                                <option value="3">3 Stars</option>
                                <option value="4">4 Stars</option>
                                <option value="5">5 Stars</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditModal(feedbackId, comment, rate,movieId,username) {
            $('#editFeedbackId').val(feedbackId);
            $('#editComment').val(comment);
            $('#editUsername').val(username);
            $('#editMovieId').val(movieId);
            $('#editRate').val(rate);
            var editModal = new bootstrap.Modal(document.getElementById('editFeedbackModal'));
            editModal.show();
        }
    </script>
</body>
</html>
