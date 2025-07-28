import React, {
  ReactNode,
  MouseEvent,
  cloneElement,
  isValidElement,
  ReactElement,
} from 'react';
import styles from './button.module.scss';
import { Icon } from '../Icon';

interface ButtonProps {
  children?: ReactNode;
  onClick?: (e: MouseEvent) => void;
  prefix?: ReactNode;
  suffix?: ReactNode;
  template?: 'red' | 'blue' | 'green';
  size?: 'sm' | 'md' | 'lg';
  href?: string;
  target?: string;
  disabled?: boolean;
  loading?: boolean;
  className?: string;
  submit?: boolean;
  form?: string;
  isActive?: boolean;
  asChild?: boolean;
}

const Button = ({
  children,
  onClick,
  prefix,
  suffix,
  template = 'red',
  size = 'md',
  href,
  target,
  disabled = false,
  loading = true,
  className = '',
  submit = false,
  form,
  isActive = false,
  asChild = false,
}: ButtonProps) => {
  const handlePointerDown = (e: MouseEvent) => {
    if (!disabled && !loading) e.currentTarget.classList.add(styles.active);
  };

  const handlePointerUp = (e: MouseEvent) => {
    e.currentTarget.classList.remove(styles.active);
  };

  const classes = [
    styles.component,
    styles.glow,
    styles[template],
    styles[size],
    isActive && styles.active,
    disabled && styles.disabled,
    className,
  ]
    .filter(Boolean)
    .join(' ');

  const sharedProps: { [key: string]: any } = {
    className: classes,
    onClick: disabled || loading ? undefined : onClick,
    onPointerDown: handlePointerDown,
    onPointerUp: handlePointerUp,
    onPointerCancel: handlePointerUp,
    'aria-busy': loading || undefined,
    'aria-disabled': disabled || loading || undefined,
    target,
    href: disabled || loading ? undefined : href,
    form,
  };

  // контент: если loading — показываем иконку-лоадер, иначе префикс/текст/суффикс
  const content = loading ? (
    <Icon name="RefreshCcw" className={styles.loader} />
  ) : (
    <>
      {prefix && <span className={styles.prefix}>{prefix}</span>}
      <span className={styles.label}>{children}</span>
      {suffix && <span className={styles.suffix}>{suffix}</span>}
    </>
  );

  if (asChild && isValidElement(children)) {
    const child = children as ReactElement<any>;
    return cloneElement(child, {
      ...sharedProps,
      className: [child.props.className, classes].filter(Boolean).join(' '),
      children: content,
    });
  }

  const Tag = href ? 'a' : 'button';
  const tagProps: { [key: string]: any } = { ...sharedProps };
  if (Tag === 'button') tagProps.type = submit ? 'submit' : 'button';

  return <Tag {...tagProps}>{content}</Tag>;
};

export default Button;
