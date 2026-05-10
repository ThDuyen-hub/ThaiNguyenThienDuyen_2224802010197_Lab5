using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TodoApi.Data;
using TodoApi.Models;

namespace TodoApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class TodoController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TodoController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/todo
        [HttpGet]
        public IActionResult GetTodos()
        {
            var userId = int.Parse(
                User.FindFirst(
                    ClaimTypes.NameIdentifier)!.Value);

            var todos = _context.TodoItems
                .Where(x => x.UserId == userId)
                .ToList();

            return Ok(todos);
        }

        // POST: api/todo
        [HttpPost]
        public IActionResult AddTodo(TodoItem todo)
        {
            var userId = int.Parse(
                User.FindFirst(
                    ClaimTypes.NameIdentifier)!.Value);

            todo.UserId = userId;

            _context.TodoItems.Add(todo);

            _context.SaveChanges();

            return Ok(todo);
        }

        // PUT: api/todo/1
        [HttpPut("{id}")]
        public IActionResult UpdateTodo(
            int id,
            TodoItem updatedTodo)
        {
            var todo =
                _context.TodoItems
                .FirstOrDefault(x => x.Id == id);

            if (todo == null)
            {
                return NotFound();
            }

            todo.Title =
                updatedTodo.Title;

            todo.IsCompleted =
                updatedTodo.IsCompleted;

            _context.SaveChanges();

            return Ok(todo);
        }

        // DELETE: api/todo/1
        [HttpDelete("{id}")]
        public IActionResult DeleteTodo(int id)
        {
            var todo =
                _context.TodoItems
                .FirstOrDefault(x => x.Id == id);

            if (todo == null)
            {
                return NotFound();
            }

            _context.TodoItems.Remove(todo);

            _context.SaveChanges();

            return Ok("Deleted");
        }
    }
}