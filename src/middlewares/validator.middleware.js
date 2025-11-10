import { validationResult } from 'express-validator';

/**
 * Middleware để xử lý kết quả validation
 */
export const validateRequest = (req, res, next) => {
  const errors = validationResult(req);
  
  if (!errors.isEmpty()) {
    // Log validation errors for debugging
    console.error('Validation errors:', {
      path: req.path,
      method: req.method,
      body: req.body,
      errors: errors.array(),
    });
    
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors: errors.array().map(err => ({
        field: err.path || err.param,
        message: err.msg,
        value: err.value,
      })),
    });
  }
  
  next();
};

export default validateRequest;

