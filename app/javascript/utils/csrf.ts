export const getCSRFToken = (): string => {
    const csrfElement = document.querySelector("[name='csrf-token']") as HTMLTemplateElement
    if (!csrfElement)
        throw new Error('csrf-token element not found')
    const token = csrfElement.content as any
    return token
}

export const createFetchHeaders = (csrfToken: string) => {
    return {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
    }
}