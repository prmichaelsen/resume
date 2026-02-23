import { useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import '../styles/navbar.css'

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false)
  const location = useLocation()

  const isActive = (path: string) => location.pathname === path

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <Link to="/" className="navbar-logo">
          Patrick Michaelsen
        </Link>

        {/* Desktop Navigation */}
        <ul className="navbar-menu">
          <li>
            <Link 
              to="/" 
              className={isActive('/') ? 'active' : ''}
            >
              Home
            </Link>
          </li>
          <li>
            <Link 
              to="/portfolio" 
              className={isActive('/portfolio') ? 'active' : ''}
            >
              Portfolio
            </Link>
          </li>
          <li>
            <Link 
              to="/cv" 
              className={isActive('/cv') ? 'active' : ''}
            >
              CV
            </Link>
          </li>
        </ul>

        {/* Mobile Hamburger */}
        <button 
          className="hamburger"
          onClick={() => setIsOpen(!isOpen)}
          aria-label="Toggle menu"
        >
          <span></span>
          <span></span>
          <span></span>
        </button>
      </div>

      {/* Mobile Menu */}
      {isOpen && (
        <div className="mobile-menu">
          <Link 
            to="/" 
            className={isActive('/') ? 'active' : ''}
            onClick={() => setIsOpen(false)}
          >
            Home
          </Link>
          <Link 
            to="/portfolio" 
            className={isActive('/portfolio') ? 'active' : ''}
            onClick={() => setIsOpen(false)}
          >
            Portfolio
          </Link>
          <Link 
            to="/cv" 
            className={isActive('/cv') ? 'active' : ''}
            onClick={() => setIsOpen(false)}
          >
            CV
          </Link>
        </div>
      )}
    </nav>
  )
}
